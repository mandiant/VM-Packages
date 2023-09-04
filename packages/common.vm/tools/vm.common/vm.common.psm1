# Setting this to "Stop". Functions should properly handle errors or throw to calling function.
$ErrorActionPreference = 'Stop'


# ################################################################################################ #
# \ \ ---------------------------------------- N O T E ---------------------------------------- / /
#
#     Below are general helper functions for any VM package to use
#
# ################################################################################################ #

function VM-ConvertFrom-Json([object] $item) {
<#
.SYNOPSIS
    Convert a JSON string into a hash table

.DESCRIPTION
    Convert a JSON string into a hash table, without any validation

.OUTPUTS
    [hashtable] or $null
#>
    Add-Type -Assembly system.web.extensions
    $ps_js = New-Object system.web.script.serialization.javascriptSerializer

    try {
        $result = $ps_js.DeserializeObject($item)
    } catch {
        $result = $null
    }

    # Cast dictionary to hashtable
    [hashtable] $result
}


function VM-Remove-PreviousZipPackage {
<#
.DESCRIPTION
    Remove files from previous zips for upgrade. They should be listed in a *.txt file.
    If no expression is provided, it will look for files matching: *.zip.txt and *.7z.txt
.PARAMETER packagePath
    Path to the chocolatey package (usually %PROGRAMDATA%\Chocolatey\lib\<package_name>)
.PARAMETER expression
    [OPTIONAL] A wildcard expression for a file type containing a list of files to delete.
#>
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $packagePath,
        [Parameter(Mandatory=$false)]
        [string] $expression=$null
    )
    if ($expression) {
        $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath $expression)
    } else {
        $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath "*.zip.txt"), (Join-Path $packagePath "*.7z.txt")
    }

    foreach ($zipFileName in $previousZipFiles) {
        if ((Test-Path -Path $zipFileName)) {
        $zipContents = @(Get-Content $zipFileName -Force)
        if ($zipContents) {
          foreach ($fileInZip in $zipContents) {
              if (($null -ne $fileInZip) -AND ($fileInZip.Trim() -ne '') -AND (Test-Path $fileInZip)) {
                  Remove-Item -Path $fileInZip -Recurse -Force -ea 0
              }
          }
        }
        }
    }
}

function VM-Write-Log {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
        [String] $level,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $message
    )
    # Get log file
    $envVarName = "VM_COMMON_DIR"
    $commonDirPath = [Environment]::GetEnvironmentVariable($envVarName, 2)
    $logFile = Join-Path $commonDirPath "log.txt"

    # If log file doesn't exist, create it
    if (-Not (Test-Path $logFile)) {
        New-Item -Path $logFile -ItemType file -Force | Out-Null
    }

    # Log message to file
    $stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    try {
        $scriptName = Split-Path -Path $MyInvocation.ScriptName -Leaf
        if ((${Env:chocolateyPackageFolder}) -AND (Test-Path env:\"chocolateyPackageFolder")) {
            $choco_dir = Split-Path -Path ${Env:chocolateyPackageFolder} -Leaf
            $line = "$stamp [$choco_dir] $scriptName [+] $level : $message"
        } else {
            $line = "$stamp $scriptName [+] $level : $message"
        }
    } catch {
        $line = "$stamp [+] $level : $message"
    }
    Add-Content $logfile -Value $line

    # Log message to console
    if (($level -eq "ERROR") -Or ($level -eq "FATAL")) {
        Write-Host -ForegroundColor Red -BackgroundColor White "$line"
    } elseif ($level -eq "WARN") {
        Write-Host -ForegroundColor Yellow "$line"
    } else {
        Write-Host "$line"
    }
}

function VM-Assert-Path {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String] $path
    )

    if (-Not (Test-Path $path)) {
        $err_msg = "Invalid path: $path"
        VM-Write-Log "ERROR" $err_msg
        throw $err_msg
    }
}

function VM-Get-DiskSize {
    $diskdrive = "${Env:SystemDrive}"
    $driveName = $diskdrive.substring(0, $diskdrive.length-1)
    $disk = Get-PSDrive "$driveName"
    $disksize = (($disk.used + $disk.free)/1GB)
    return $disksize
}

function VM-Get-FreeSpace {
    [double]$freeSpace = 0.0
    [string]$wql = "SELECT * FROM Win32_LogicalDisk WHERE MediaType=12"
    $drives = Get-CIMInstance -query $wql
    if($null -ne $drives) {
        foreach($drive in $drives) {
            $freeSpace += ($drive.freeSpace)
        }
    }

    return ($freeSpace / 1GB)
}

function VM-Check-Reboot {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String] $package
    )
    try {
        if (Test-PendingReboot){
            VM-Write-Log "ERROR" "[Err] Host must be rebooted before continuing install of $package.`n"
            Invoke-Reboot
            exit 1
        }
    } catch {
        continue
    }
}

function VM-New-Install-Log {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String] $dir
    )
    VM-Assert-Path $dir
    $outputFile = Join-Path $dir "install_log.txt"
    if (-Not (Test-Path $outputFile)) {
        New-Item -Path $outputFile -Force | Out-Null
    }
    $(Get-Date -f o) | Out-File -FilePath $outputFile -Append
    return $outputFile
}

# This functions returns $toolDir
function VM-Install-Raw-GitHub-Repo {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $zipUrl,
        [Parameter(Mandatory=$true, Position=3)]
        [string] $zipSha256,
        # Examples:
        # $powershellCommand = "Get-Content README.md"
        # $powershellCommand = "Import-Module module.ps1; Get-Help Main-Function"
        [Parameter(Mandatory=$false)]
        [string] $powershellCommand
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
        $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

        # Remove files from previous zips for upgrade
        VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

        # Create a temp directory to download zip
        $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"

        # Download and unzip
        $packageArgs = @{
            packageName    = ${Env:ChocolateyPackageName}
            unzipLocation  = $tempDownloadDir
            url            = $zipUrl
            checksum       = $zipSha256
            checksumType   = 'sha256'
        }
        Install-ChocolateyZipPackage @packageArgs | Out-Null
        VM-Assert-Path $tempDownloadDir

        # Make sure our tool directory exists
        if (-Not (Test-Path $toolDir)) {
            New-Item -Path $toolDir -ItemType Directory -Force | Out-Null
        }

        # Get the unzipped directory
        $unzippedDir = (Get-ChildItem -Directory $tempDownloadDir | Where-Object {$_.PSIsContainer} | Select-Object -f 1).FullName

        # Copy all the items in the unzipped directory to their correct directory
        Get-ChildItem -Path $unzippedDir | Move-Item -Destination $toolDir -Force -ea 0

        # Sleep to help prevent file system race conditions
        Start-Sleep -Milliseconds 500

        # Rename all entries in to where the files were actually copied
        $zip_name = Join-Path ${Env:chocolateyPackageFolder} ((Split-Path $unzippedDir -Leaf) + ".zip.txt")
        (Get-Content $zip_name) | Foreach-Object {$_.Replace($unzippedDir, $toolDir)} | Set-Content $zip_name

        # Remove first line of *.zip.txt file so we don't delete the entire directory on upgrade
        (Get-Content $zip_name | Select-Object -Skip 1) | Set-Content $zip_name

        # Sleep to help prevent file system race conditions
        Start-Sleep -Milliseconds 500

        # Attempt to remove temporary directory
        Remove-Item $tempDownloadDir -Recurse -Force -ea 0

        if ($powershellCommand) {
            $executableArgs = "-ExecutionPolicy Bypass -NoExit -Command $powershellCommand"
            $powershellPath = Join-Path "${Env:WinDir}\system32\WindowsPowerShell\v1.0" "powershell.exe" -Resolve
            $shortcut = Join-Path $shortcutDir "$toolName.lnk"
            Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $powershellPath -Arguments $executableArgs -WorkingDirectory $toolDir -IconLocation $powershell
        } else {
            $shortcut = Join-Path $shortcutDir "$toolName.lnk"
            Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
        }
        VM-Assert-Path $shortcut

        return $toolDir
    } catch {
        VM-Write-Log-Exception $_
    }
}

function VM-Install-Shortcut{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $executablePath,
        [Parameter(Mandatory=$false)]
        [bool] $consoleApp=$false,
        [Parameter(Mandatory=$false)]
        [switch] $runAsAdmin=$false,
        [Parameter(Mandatory=$false)]
        [string] $executableDir,
        [Parameter(Mandatory=$false)]
        [string] $arguments = "--help"
    )
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    if ($consoleApp) {
        if (!$executableDir) {
            $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
        }
        VM-Assert-Path $executableDir

        $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
        # Change to executable dir, print command to execute, and execute command
        $executableArgs = "/K `"cd `"$executableDir`" && echo $executableDir^> $executablePath $arguments && `"$executablePath`" $arguments`""
        Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath -RunAsAdmin $runAsAdmin
    } else {
        Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $executablePath -RunAsAdmin $runAsAdmin
    }
    VM-Assert-Path $shortcut
}

# This functions returns $toolDir (outputed by Install-ChocolateyZipPackage) and $executablePath
function VM-Install-From-Zip {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $zipUrl,
        [Parameter(Mandatory=$false)]
        [string] $zipSha256,
        [Parameter(Mandatory=$false)]
        [string] $zipUrl_64,
        [Parameter(Mandatory=$false)]
        [string] $zipSha256_64,
        [Parameter(Mandatory=$false)]
        [bool] $consoleApp=$false,
        [Parameter(Mandatory=$false)]
        [bool] $innerFolder=$false, # Subfolder in zip with the app files
        [Parameter(Mandatory=$false)]
        [string] $arguments = "--help",
        [Parameter(Mandatory=$false)]
        [string] $executableName, # Executable name, needed if different from "$toolName.exe"
        [Parameter(Mandatory=$false)]
        [switch] $withoutBinFile # Tool should not be installed as a bin file
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

        # Remove files from previous zips for upgrade
        VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

        # Snapshot all folders in $toolDir
        $oldDirList = @()
        if (Test-Path $toolDir) {
            $oldDirList = @(Get-ChildItem $toolDir | Where-Object {$_.PSIsContainer})
        }

        # Download and unzip
        $packageArgs = @{
            packageName    = ${Env:ChocolateyPackageName}
            unzipLocation  = $toolDir
            url            = $zipUrl
            checksum       = $zipSha256
            checksumType   = 'sha256'
            url64bit       = $zipUrl_64
            checksum64     = $zipSha256_64
        }
        Install-ChocolateyZipPackage @packageArgs
        VM-Assert-Path $toolDir

        # Diff and find new folders in $toolDir
        $newDirList = @(Get-ChildItem $toolDir | Where-Object {$_.PSIsContainer})
        $diffDirs = Compare-Object -ReferenceObject $oldDirList -DifferenceObject $newDirList -PassThru

        # If $innerFolder is set to $true, after unzipping only a single folder should be new.
        # GitHub ZIP files typically unzip to a single folder that contains the tools.
        if ($innerFolder) {
            # First time install, use the single resulting folder name from Install-ChocolateyZipPackage.
            if ($diffDirs.Count -eq 1) {
                # Save the "new tool directory" to assist with upgrading.
                $newToolDir = Join-Path $toolDir $diffDirs[0].Name -Resolve
                Set-Content (Join-Path ${Env:chocolateyPackageFolder} "innerFolder.txt") $newToolDir
                $toolDir = $newToolDir
            } else {
                # On upgrade there may be no new directory, in this case retrieve previous "new tool directory" from saved file.
                $toolDir = Get-Content (Join-Path ${Env:chocolateyPackageFolder} "innerFolder.txt")
            }
        }

        if (-Not $executableName) { $executableName = "$toolName.exe" }
        $executablePath = Join-Path $toolDir $executableName -Resolve
        VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments
        if (-Not $withoutBinFile) { Install-BinFile -Name $toolName -Path $executablePath }
        return $executablePath
    } catch {
        VM-Write-Log-Exception $_
    }
}

# This functions returns $executablePath
function VM-Install-Single-Exe {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $exeUrl,
        [Parameter(Mandatory=$false)]
        [string] $exeSha256,
        [Parameter(Mandatory=$false)]
        [string] $exeUrl_64,
        [Parameter(Mandatory=$false)]
        [string] $exeSha256_64,
        [Parameter(Mandatory=$false)]
        [bool] $consoleApp=$false,
        [Parameter(Mandatory=$false)]
        [string] $arguments = "--help"
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

        # Get the file extension from the URL
        $ext = (Split-Path -Path $exeUrl -Leaf).Split(".")[-1]

        # Download and install
        $executablePath = Join-Path $toolDir "$toolName.$ext"
        $packageArgs = @{
            packageName = ${Env:ChocolateyPackageName}
            url = $exeUrl
            checksum = $exeSha256
            checksumType = "sha256"
            url64bit = $exeUrl_64
            checksum64 = $exeSha256_64
            fileFullPath = $executablePath
            forceDownload = $true
        }
        Get-ChocolateyWebFile @packageArgs
        VM-Assert-Path $executablePath

        VM-Install-Shortcut -toolName $toolName -category $category -executableDir $toolDir -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments
        Install-BinFile -Name $toolName -Path $executablePath
        return $executablePath
    } catch {
        VM-Write-Log-Exception $_
    }
}

# This functions returns $scriptPath
function VM-Install-Single-Ps1 {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $ps1Url,
        [Parameter(Mandatory=$false)]
        [string] $ps1Sha256,
        [Parameter(Mandatory=$false)]
        [string] $ps1Url_64,
        [Parameter(Mandatory=$false)]
        [string] $ps1Sha256_64,
        [Parameter(Mandatory=$false)]
        [string] $ps1Cmd
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
        $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

        # Download and install
        $scriptPath = Join-Path $toolDir "$toolName.ps1"
        $packageArgs = @{
            packageName = ${Env:ChocolateyPackageName}
            url = $ps1Url
            checksum = $ps1Sha256
            checksumType = "sha256"
            url64bit = $ps1Url_64
            checksum64 = $ps1Sha256_64
            fileFullPath = $scriptPath
            forceDownload = $true
        }
        Get-ChocolateyWebFile @packageArgs
        VM-Assert-Path $scriptPath

        $shortcut = Join-Path $shortcutDir "$toolName.lnk"
        $targetCmd = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve

        if ($ps1Cmd) {
            $targetArgs = "/K powershell.exe -ExecutionPolicy Bypass -NoExit -Command `"cd '$toolDir'; $ps1Cmd`""
        } else {
            $targetArgs = "/K powershell.exe -ExecutionPolicy Bypass -NoExit -Command `"cd '$toolDir'`""
        }
        $targetIcon = Join-Path (Join-Path ${Env:WinDir} "system32\WindowsPowerShell\v1.0") "powershell.exe" -Resolve

        Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $targetCmd -arguments $targetArgs -workingDirectory $toolDir -iconLocation $targetIcon
        VM-Assert-Path $shortcut
        return $scriptPath
    } catch {
        VM-Write-Log-Exception $_
    }
}

function VM-Uninstall {
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category
    )
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Remove tool files
    Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

    # Remove tool shortcut
    VM-Remove-Tool-Shortcut $toolName $category

    # Uninstall binary
    Uninstall-BinFile -Name $toolName
}

function VM-Remove-Tool-Shortcut {
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $shortcutName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category
    )
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$shortcutName.lnk"
    Remove-Item $shortcut -Force -ea 0 | Out-Null
}

function VM-Install-With-Installer {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [ValidateSet("EXE", "MSI")]
        [string] $fileType,
        [Parameter(Mandatory=$true, Position=3)]
        # Some general silent args:
        # $silentArgs = '/qn /norestart' # MSI
        # $silentArgs = '/S'             # NSIS
        # $silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
        #   Can also specify an install directory for Inno Setup via /DIR=`"<path>`"
        # $silentArgs = '/s'             # InstallShield
        # $silentArgs = '/s /v"/qn"'     # InstallShield with MSI
        # $silentArgs = '/s'             # Wise InstallMaster
        # $silentArgs = '-s'             # Squirrel
        # $silentArgs = '-q'             # Install4j
        # $silentArgs = '-s -u'          # Ghost
        [string] $silentArgs,
        [Parameter(Mandatory=$true, Position=4)]
        [string] $executablePath,
        [Parameter(Mandatory=$true, Position=5)]
        [string] $url,
        [Parameter(Mandatory=$false)]
        [string] $sha256,
        [Parameter(Mandatory=$false)]
        [array] $validExitCodes= @(0, 3010, 1605, 1614, 1641),
        [Parameter(Mandatory=$false)]
        [bool] $consoleApp=$false,
        [Parameter(Mandatory=$false)]
        [string] $arguments = "--help"
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

        # Get the file extension from the URL
        $installerName = Split-Path -Path $url -Leaf
        $ext = $installerName.Split(".")[-1].ToLower()

        # Download and install
        $packageArgs = @{
            packageName   = ${Env:ChocolateyPackageName}
            url           = $url
            checksum      = $sha256
            checksumType  = "sha256"
        }
        if ($ext -in @("zip", "7z")) {
            VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}
            $unzippedDir= Join-Path $toolDir "$($toolName)_installer"
            $packageArgs['unzipLocation'] = $unzippedDir
            Install-ChocolateyZipPackage @packageArgs
            VM-Assert-Path $unzippedDir

            $exePaths = Get-ChildItem $unzippedDir | Where-Object { $_.Name.ToLower() -match '^.*\.(exe|msi)$' }
            if ($exePaths.Count -eq 1) {
                $installerPath = $exePaths[0].FullName
            } else {
                $exePaths = Get-ChildItem $unzippedDir | Where-Object { $_.Name.ToLower() -match '^.*(setup|install).*\.(exe|msi)$' }
                if ($exePaths.Count -eq 1) {
                    $installerPath = $exePaths[0].FullName
                } else {
                    throw "Unable to determine installer file within: $unzippedDir"
                }
            }
        } else {
            $installerPath = Join-Path $toolDir $installerName
            $packageArgs['fileFullPath'] = $installerPath
            Get-ChocolateyWebFile @packageArgs
            VM-Assert-Path $installerPath
        }

        # Install tool via native installer
        $packageArgs = @{
            packageName   = ${Env:ChocolateyPackageName}
            fileType      = $fileType
            file          = $installerPath
            silentArgs    = $silentArgs
            validExitCodes= $validExitCodes
            softwareName  = $toolName
        }
        Install-ChocolateyInstallPackage @packageArgs
        VM-Assert-Path $executablePath

        VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments
        Install-BinFile -Name $toolName -Path $executablePath
    } catch {
        VM-Write-Log-Exception $_
    }
}

function VM-Uninstall-With-Uninstaller {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $softwareName,
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateSet("EXE", "MSI")]
        [string] $fileType,
        [Parameter(Mandatory=$true, Position=2)]
        # Some general silent args:
        # $silentArgs = '/qn /norestart' # MSI
        # $silentArgs = '/S'             # NSIS
        # $silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
        # $silentArgs = '/s'             # InstallShield
        # $silentArgs = '/s /v"/qn"'     # InstallShield with MSI
        # $silentArgs = '/s'             # Wise InstallMaster
        # $silentArgs = '-s'             # Squirrel
        # $silentArgs = '-q'             # Install4j
        # $silentArgs = '-s -u'          # Ghost
        [string] $silentArgs,
        [Parameter(Mandatory=$false)]
        [array] $validExitCodes= @(0, 3010, 1605, 1614, 1641)
    )
    # Attempt to find and execute the uninstaller, may need to use wildcards
    # See: https://docs.chocolatey.org/en-us/create/functions/get-uninstallregistrykey
    [array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName
    if ($key.Count -eq 1) {
        $packageArgs = @{
            packageName    = ${Env:ChocolateyPackageName}
            fileType       = $fileType
            silentArgs     = $silentArgs
            # May need to remove arguments if present, but leaving for future TODO
            file           = $key[0].UninstallString
            validExitCodes = $validExitCodes
        }
        if ($fileType -eq 'MSI') {
            $packageArgs['silentArgs'] = "$($key[0].PSChildName) $silentArgs"
            $packageArgs['file'] = ''
        }
        Uninstall-ChocolateyPackage @packageArgs
    } elseif ($key.Count -eq 0) {
        VM-Write-Log "WARN" "${Env:ChocolateyPackageName} has already been uninstalled by other means."
    } elseif ($key.Count -gt 1) {
        VM-Write-Log "WARN" "$($key.Count) matches found!"
        VM-Write-Log "WARN" "To prevent accidental data loss, no targeted uninstallation will occur."
        VM-Write-Log "WARN" "The following installation values were found:"
        $key | ForEach-Object {VM-Write-Log "WARN" " - $($_.DisplayName)"}
        VM-Write-Log "WARN" "Now allowing Chocolatey's auto uninstaller a chance to run."
    }
}

function VM-Write-Log-Exception {
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ErrorRecord] $error_record
    )
    $msg = $error_record.Exception.Message
    $position_msg = $error_record.InvocationInfo.PositionMessage
    VM-Write-Log "ERROR" "[ERR] $msg`r`n$position_msg"
    throw $error_record
}

function VM-Add-To-Right-Click-Menu {
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String] $menuKey, # name of registry key
        [Parameter(Mandatory=$true, Position=1)]
        [string] $menuLabel, # value displayed in right-click menu
        [Parameter(Mandatory=$true, Position=2)]
        [string] $command,
        [Parameter(Mandatory=$true, Position=3)]
        [ValidateSet("file", "directory")]
        [string] $type,
        [Parameter(Mandatory=$false, Position=4)]
        [string] $menuIcon
    )
    try {
        # Determine if file or directory should show item in right-click menu
        if ($type -eq "file") {
            $key = "*"
        } else {
            $key = "directory"
        }
        $key_path = "HKCR:\$key\shell\$menuKey"

        # Check and map "HKCR" to correct drive
        if (-NOT (Test-Path -path 'HKCR:')) {
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
        }

        # Add right-click menu display name
        if (-NOT (Test-Path -LiteralPath $key_path)) {
            New-Item -Path $key_path | Out-Null
        }
        Set-ItemProperty -LiteralPath $key_path -Name '(Default)' -Value "$menuLabel" -Type String
        if ($menuIcon) {
          Set-ItemProperty -LiteralPath $key_path -Name 'Icon' -Value "$menuIcon" -Type String
        }

        # Add command to run when executed from right-click menu
        if(-NOT (Test-Path -LiteralPath "$key_path\command")) {
            New-Item -Path "$key_path\command" | Out-Null
        }
        Set-ItemProperty -LiteralPath "$key_path\command" -Name '(Default)' -Value $command -Type String
    } catch {
        VM-Write-Log "ERROR" "Failed to add $menuKey to right-click menu"
    }
}

function VM-Remove-From-Right-Click-Menu {
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String] $menuKey, # name of registry key
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateSet("file", "directory")]
        [string] $type
    )
    try {
        # Determine if file or directory should show item in right-click menu
        if ($type -eq "file") {
            $key = "*"
        } else {
            $key = "directory"
        }
        $key_path = "HKCR:\$key\shell\$menuKey"

        # Check and map "HKCR" to correct drive
        if (-NOT (Test-Path -path 'HKCR:')) {
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
        }

        # Remove right-click menu settings from registry
        if (Test-Path -LiteralPath $key_path) {
            Remove-Item -LiteralPath $key_path -Recurse
        }
    } catch {
        VM-Write-Log "ERROR" "Failed to remove $menuKey from right-click menu"
    }
}

function VM-Get-Host-Info {
    $survey = @"
Host Information

VM OS version and Service Pack
-----
{0}

VM OS RAM (MB)
-----
{1}

VM OS HDD Space / Usage
-----
{2}

VM AV Details
-----
{3}

VM PowerShell Version
-----
{4}

VM CLR Version
-----
{5}

VM Chocolatey Version
-----
{6}

VM Boxstarter Version
-----
{7}

VM Installed Packages
-----
{8}

Common Environment Variables
-----
{9}

"@

    # Credit: https://blog.idera.com/database-tools/identifying-antivirus-engine-state
    # Define bit flags
    [Flags()] enum ProductState
    {
        Off         = 0x0000
        On          = 0x1000
        Snoozed     = 0x2000
        Expired     = 0x3000
    }

    [Flags()] enum SignatureStatus
    {
        UpToDate     = 0x00
        OutOfDate    = 0x10
    }

    [Flags()] enum ProductOwner
    {
        NonMicrosoft = 0x000
        Microsoft    = 0x100
    }

    [Flags()] enum ProductFlags
    {
        SignatureStatus = 0x00F0
        ProductOwner    = 0x0F00
        ProductState    = 0xF000
    }

    $osInfo = (Get-CimInstance win32_operatingsystem) | Select-Object Version, BuildNumber, OSArchitecture, ServicePackMajorVersion, Caption | Out-String
    $memInfo = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1mb | Out-String
    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk | Out-String
    $psInfo = $PSVersionTable.PSVersion
    $psInfoClr = $PSVersionTable.CLRVersion
    $chocoInfo = choco --version
    $installedPackages = choco list -r
    $boxstarerInfo = $installedPackages | Select-String -Pattern "Boxstarter" | Out-String
    $installedPackages = $installedPackages | Out-String

    $namespaceName = $null
    # Determine if the namespace exists
    # TODO: Seems this works sometimes... need to look further into how to get system AV information
    $cimclassname = Get-CimClass -namespace 'root/cimv2' | Where-Object cimclassname -eq 'AntiVirusProduct' | Select-Object cimclassname
    if ($null -ne $cimclassname.CimClassName) {
        if (Get-CimInstance -Namespace 'root' -ClassName 'AntiVirusProduct' -Filter 'Name="SecurityCenter2"' -ComputerName ${Env:computername}) {
            $namespaceName = 'root/SecurityCenter2'
        } elseif (Get-CimInstance -Namespace 'root' -ClassName 'AntiVirusProduct' -Filter 'Name="SecurityCenter"' -ComputerName ${Env:computername}) {
            $namespaceName = 'root/SecurityCenter'
        } else {
          $avInfoFormatted = "root/SecurityCenter* namespace does not exist..."
        }
        if (-not [string]::IsNullOrEmpty($namespaceName)) {
          $avInfo = Get-CimInstance -Namespace $namespaceName -Class 'AntiVirusProduct' ./.git-ComputerName ${Env:computername}
          # Decode bit flags by masking the relevant bits, then converting
          $avInfoFormatted = @"
DisplayName: $($avInfo.displayName)
ProductOwner: $([ProductOwner]([UInt32]$avInfo.productState -band [ProductFlags]::ProductOwner))
ProductState: $([ProductState]([UInt32]$avInfo.productState -band [ProductFlags]::ProductState))
SignatureStatus: $([SignatureStatus]([UInt32]$avInfo.productState -band [ProductFlags]::SignatureStatus))
"@
        }
    } else {
      $avInfoFormatted = "AntiVirusProduct classname does not exist..."
    }

    $envVars = @"
VM_COMMON_DIR: ${Env:VM_COMMON_DIR}
TOOL_LIST_DIR: ${Env:TOOL_LIST_DIR}
TOOL_LIST_SHORTCUT: ${Env:TOOL_LIST_SHORTCUT}
RAW_TOOLS_DIR: ${Env:RAW_TOOLS_DIR}
"@

    VM-Write-Log "INFO" "$($survey -f $osInfo, $memInfo, $diskInfo, $avInfoFormatted, $psInfo, $psInfoClr, $chocoInfo, $boxstarerInfo, $installedPackages, $envVars)"
}

function VM-Remove-Appx-Package {
# Function for removing Apps
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$appName
    )

    try {
        # Check if the app is installed
        $installedPackage = Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue
        
        if ($installedPackage) {
            $packageFullName = $installedPackage.PackageFullName
            $result = Remove-AppxPackage -Package $packageFullName -ErrorAction Stop

            if ($null -eq $result) {
                VM-Write-Log "INFO" "[+] Installed $appName has been successfully removed."
            } else {
                VM-Write-Log "ERROR" "[+] Failed to remove installed app $appName."
            }
        }
        else {
            VM-Write-Log "WARN" "[+] Installed $appName not found on the system."
        }
        # Check if the app is provisioned
        $provisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $appName } -ErrorAction SilentlyContinue
        if ($provisionedPackage) {
            $result = Remove-AppxProvisionedPackage -PackageName $provisionedPackage.PackageName -Online  

            if ($result) {
                VM-Write-Log "INFO" "[+] Provisioned $appName has been successfully removed."
            } else {
                VM-Write-Log "ERROR" "[+] Failed to remove porvisioned app $appName."
            }
        } else {
            VM-Write-Log "WARN" "[+] Provisioned $appName not found on the system."
        }
    } 
    catch {
        VM-Write-Log "ERROR" "An error occurred while removing the app or provisioned package. Error: $_"
    }
}


function VM-Set-Service-Manual-Start {
# Function for setting Services to manual startup
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$serviceName
    )

    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop

        if ($service) {
            $service | Set-Service -StartupType Manual -ErrorAction Stop
            VM-Write-Log "INFO" "[+] Service $serviceName has been disabled."
        } else {
            VM-Write-Log "WARN" "[+] Service $serviceName not found."
        }
    }
    catch {
        VM-Write-Log "ERROR" "An error occurred while setting the service startup type. Error: $_"
    }
}

function VM-Disable-Scheduled-Task {
# Function for disabling scheduled tasks
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$value
    )

    try {
        $output = Disable-ScheduledTask -TaskName $value -ErrorAction SilentlyContinue
        if ($output){
            VM-Write-Log "INFO" "[+] Scheduled task '$name' has been disabled."
        }
        else{
            VM-Write-Log "ERROR" "[+] Scheduled task '$name' not found."
        }
    
    }
    catch {
        VM-Write-Log "ERROR" "An error occurred while disabling the '$name' scheduled task. Error: $_"
    }
}

function VM-Update-Registry-Value {
# Function for setting Registry items
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $path,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $value,

        [Parameter(Mandatory=$true)]
        [ValidateSet("String", "ExpandString", "Binary", "DWord", "QWord", "MultiString", "Unknown")]
        [string] $type,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $data
    )

    try {
        # Validate the value based on the type parameter
        if ($type -eq "DWord" -or $type -eq "QWord") {
            $validatedData = [int64]::Parse($data)
        }
        elseif ($type -eq "Binary") {
            $validatedData = [byte[]]::new(($data -split '(.{2})' | Where-Object { $_ -match '..' } | ForEach-Object { [convert]::ToByte($_, 16) }))

        }
        else {
            $validatedData = $data
        }

        # check if path exists. If not, create the path for the registry value
        if (!(Test-Path -Path $path)) {
            # Create the registry key
            New-Item -Path $path -Force | Out-Null
            VM-Write-Log "INFO" "`t[+] Registry key created: $path"
        }
        else {
            VM-Write-Log "WARN" "`t[+] Registry key already exists: $path"
        }

        Set-ItemProperty -Path $path -Name $value -Value $validatedData -Type $type -Force | Out-Null
        VM-Write-Log "INFO" "[+] $name has been successful"
    }
    catch {
        VM-Write-Log "ERROR" "Failed to update the registry value. Error: $_"
    }
}

function VM-Remove-Path {
# Function for removing Paths/Programs
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$name,

        [Parameter(Mandatory=$true)]
        [ValidateSet("file", "dir")]
        [string]$type,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$path
    )

    try {
        if ($type -eq "file") {
            if (Test-Path -Path $path -PathType Leaf) {
                Remove-Item -Path $path -Force
                VM-Write-Log "INFO" "[+] $name has been successfully removed."
            } else {
                VM-Write-Log "WARN" "[+] $path does not exist."
            }
        }
        elseif ($type -eq "dir") {
            if (Test-Path -Path $path -PathType Container) {
                Remove-Item -Path $path -Recurse -Force
                VM-Write-Log "INFO" "[+] $name has been successfully removed."
            } else {
                VM-Write-Log "WARN" "[+] $path does not exist."
            }
        }
    }
    catch {
        VM-Write-Log "ERROR" "An error occurred while removing the $type $path. Error: $_"
    }
}

function VM-Execute-Custom-Command{
# Function for removing items in need of custom code.
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$cmds
    )

    try {
        Write-Output "[+] Executing commands for '$name':"
        foreach ($cmd in $cmds) {
            Write-Output "`t[+] Executing command: $cmd"
            start-process powershell -ArgumentList "-WindowStyle","Hidden","-Command",$cmd -Wait
            Write-Host "`t[+] Process completed. Moving to next."
        }
        Write-Output "[+] All commands for '$name' have been executed successfully."
    }
    catch {
        VM-Write-Log "ERROR" "An error occurred while executing commands for '$name'. Error: $_"
    }
}

function VM-Configure-Prompts {
    # $Env:MandiantVM must be set in the install script
    $psprompt = @"
        function prompt {
            Write-Host (`$Env:MandiantVM + " " + `$(Get-Date)) -ForegroundColor Green
            Write-Host ("PS " + `$(Get-Location) + " >") -NoNewLine -ForegroundColor White
            return " "
        }
"@

    # Ensure profile file exists and append new content to it, not overwriting old content
    if (!(Test-Path $profile)) {
        New-Item -ItemType File -Path $profile -Force | Out-Null
    }
    Add-Content -Path $profile -Value $psprompt

    # Add timestamp to cmd prompt
    ## Configure the command
    $mandiantVM = $Env:MandiantVM -replace ' ', '' # setx command cannot have spaces
    $command = "cmd /c 'setx PROMPT $mandiantVM`$S`$d`$s`$t`$_`$p$+`$g'"
    ## Convert to base64
    $base64 = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
    ## Run command
    Invoke-Expression ([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64))) | Out-Null

    Write-Host "[+] Timestamps added to cmd prompt and PowerShell" -ForegroundColor Green
}

function VM-Configure-PS-Logging {
    if ($PSVersionTable -And $PSVersionTable.PSVersion.Major -ge 5) {
        Write-Host "[+] Enabling PowerShell Script Block Logging" -ForegroundColor Green

        $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell'
        if (-Not (Test-Path $psLoggingPath)) {
            New-Item -Path $psLoggingPath -Force | Out-Null
        }

        $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\Transcription'
        if (-Not (Test-Path $psLoggingPath)) {
            New-Item -Path $psLoggingPath -Force | Out-Null
        }
        New-ItemProperty -Path $psLoggingPath -Name "EnableInvocationHeader" -Value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $psLoggingPath -Name "EnableTranscripting" -Value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $psLoggingPath -Name "OutputDirectory" -Value (Join-Path ${Env:UserProfile} "Desktop\PS_Transcripts") -PropertyType String -Force | Out-Null

        $psLoggingPath = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
        if (-Not (Test-Path $psLoggingPath)) {
            New-Item -Path $psLoggingPath -Force | Out-Null
        }
        New-ItemProperty -Path $psLoggingPath -Name "EnableScriptBlockLogging" -Value 1 -PropertyType DWORD -Force | Out-Null
        Write-Host "`t[i] PowerShell transcripts will be saved to the desktop." -ForegroundColor Green
    }
}

# Main function for debloater and configuration changes
# Expects an XML file
function VM-Apply-Configurations {
    param(
        [Parameter(Position = 0)]
        [string]$configFile
    )

    try {
        # Load and parse the XML config file
        $config = [xml](Get-Content $configFile)

        # Process the apps
        if ($config.config.apps.app) {
            $config.config.apps.app | ForEach-Object {
                $appName = $_.name
                VM-Remove-Appx-Package -appName $appName
            }
        }


        # Process the services
        if ($config.config.services.service) {
            $config.config.services.service | ForEach-Object {
                $serviceName = $_.name
                VM-Set-Service-Manual-Start -serviceName $serviceName
            }
        }

        # Process the services
        if ($config.config.tasks.task) {
            $config.config.tasks.task | ForEach-Object {
                $descName = $_.name
                $taskName = $_.value
                VM-Disable-Scheduled-Task -name $descName -value $taskName
            }
        }

        # Process the registry items
        if ($config.config."registry-items"."registry-item") {
            $config.config."registry-items"."registry-item" | ForEach-Object {
                $name = $_.name
                $path = $_.path
                $value = $_.value
                $type = $_.type
                $data = $_.data
                VM-Update-Registry-Value -name $name -path $path -value $value -type $type -data $data
            }
        }

        # Process the path items
        if ($config.config."path-items"."path-item") {
            $config.config."path-items"."path-item" | ForEach-Object {
                $name = $_.name
                $type = $_.type
                $path = $_.path
                VM-Remove-Path -name $name -type $type -path $path
            }
        }

        # Process the custom items
        if ($config.config."custom-items"."custom-item") {
            $config.config."custom-items"."custom-item" | ForEach-Object {
                $name = $_.name
                $cmds = @($_.cmd | ForEach-Object { $_.value })
                VM-Execute-Custom-Command -name $name -cmds $cmds
            }
        }
    }
    catch {
        VM-Write-Log "ERROR" "An error occurred while applying config. Error: $_"
    }
}

# This function returns a string of "Win10", "Win11", or "Win11ARM"
function VM-Get-WindowsVersion {
    $osInfo = Get-ComputerInfo

    # Extract the version number and other details
    $version = $osInfo.OsName
    $osArchitecture = $osInfo.OSArchitecture

    if ($version -match "10") {
        return "Win10"
    }
    elseif ($version -match "11" -and $osArchitecture -eq "64-bit") {
        return "Win11"
    }
    elseif ($version -match "11" -and $osArchitecture -match "ARM") {
        return "Win11ARM"
    }
    else {
        return "Unknown"
    }
}

function VM-Get-InstalledPackages {
    if (Get-Command choco -ErrorAction:SilentlyContinue) {
        powershell.exe "choco list -r" | ForEach-Object {
            $Name, $Version = $_ -split '\|'
            New-Object -TypeName psobject -Property @{
                'Name' = $Name
                'Version' = $Version
            }
        }
    }
}