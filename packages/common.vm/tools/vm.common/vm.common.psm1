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

# Raise an exception if the Signature of $file_path is invalid
function VM-Assert-Signature {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String] $file_path
    )
    $signature_status = (Get-AuthenticodeSignature -FilePath $file_path).Status
    if ($signature_status -eq 'Valid') {
        VM-Write-Log "INFO" "Valid signature: $file_path"
    } else {
        $err_msg = "Invalid signature: $file_path"
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
            VM-Write-Log "ERROR" "Host must be rebooted before continuing installation of $package.`n"
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

function VM-Install-Shortcut{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$false, Position=2)]
        [string] $executablePath,
        [Parameter(Mandatory=$false)]
        [bool] $consoleApp=$false,
        [Parameter(Mandatory=$false)]
        [switch] $powershell,
        [Parameter(Mandatory=$false)]
        [switch] $runAsAdmin,
        [Parameter(Mandatory=$false)]
        [string] $executableDir,
        [Parameter(Mandatory=$false)]
        [string] $arguments = "",
        [Parameter(Mandatory=$false)]
        [string] $iconLocation
    )
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    # Set the default icon to be the executable's icon
    if (-Not $iconLocation) {$iconLocation = $executablePath}

    if (-not $executableDir) {
        $executableDir = Join-Path ${Env:UserProfile} "Desktop"
    }
    VM-Assert-Path $executableDir

    if ($consoleApp -or $powershell) {
        if ($consoleApp) {
            $executableCmd = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
            # Change to executable dir, print command to execute, and execute command
            $executableArgs = "/K `"cd `"$executableDir`" && echo $executableDir^> $executablePath $arguments && `"$executablePath`" $arguments`""
        } else {
            $executableCmd = Join-Path "${PSHome}" "powershell.exe" -Resolve
            $executableArgs = "-ExecutionPolicy Bypass -NoExit -Command `"`$cmd = '$arguments'; Write-Host `$cmd; Invoke-Expression `$cmd`""
            $iconLocation = $executableCmd
        }

        $shortcutArgs = @{
            ShortcutFilePath = $shortcut
            TargetPath       = $executableCmd
            Arguments        = $executableArgs
            WorkingDirectory = $executableDir
            IconLocation     = $iconLocation
        }
        if ($runAsAdmin) {
            $shortcutArgs.RunAsAdmin = $true
        }
        Install-ChocolateyShortcut @shortcutArgs

    } else {
        $shortcutArgs = @{
            ShortcutFilePath = $shortcut
            TargetPath       = $executablePath
            Arguments        = $arguments
            WorkingDirectory = $executableDir
            IconLocation     = $iconLocation
        }
        if ($runAsAdmin) {
            $shortcutArgs.RunAsAdmin = $true
        }
        Install-ChocolateyShortcut @shortcutArgs
    }
    VM-Assert-Path $shortcut

    # If the targets is a .bat file, change the shortcut icon to Windows default
    $extension = [System.IO.Path]::GetExtension($executablePath)
    if ($extension -eq ".bat") {
        $Shell = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $Shell.CreateShortcut($shortcut)

        $IconArrayIndex = -68 # This is the specific icon that Windows uses for .bat files by default
        $IconLocation = "C:\WINDOWS\system32\imageres.dll"
        $Shortcut.IconLocation = "$IconLocation,$IconArrayIndex"

        $Shortcut.Save()
    }
}

function VM-Get-IDA-Plugins-Dir {
  return New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\plugins" -ItemType "directory" -Force
}

# Downloads an IDA plugin file or ZIP containing a plugin (and supporting files/directories) to the plugins directory.
# For ZIPs, we check if there is an inner folder (this is the case for GH ZIPs) and if there is a directory called 'plugins'.
# We copy all files in this directory with the exception of the README and the LICENSE file (often present in GH repos).
# The copied files must include $pluginName.
function VM-Install-IDA-Plugin {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $pluginName, # Example: capa_explorer.py
        [Parameter(Mandatory=$true)]
        [string] $pluginUrl,
        [Parameter(Mandatory=$true)]
        [string] $pluginSha256
    )
    try {
        $pluginExtension = [System.IO.Path]::GetExtension($pluginUrl)
        $pluginsDir = VM-Get-IDA-Plugins-Dir
        $pluginPath = Join-Path $pluginsDir $pluginName

        if ($pluginExtension -eq ".zip") {
            $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
            # Download and unzip
            $packageArgs = @{
                packageName    = ${Env:ChocolateyPackageName}
                unzipLocation  = $tempDownloadDir
                url            = $pluginUrl
                checksum       = $pluginSha256
                checksumType   = 'sha256'
            }
            Install-ChocolateyZipPackage @packageArgs | Out-Null
            VM-Assert-Path $tempDownloadDir

            # Check if there is inner folder (for example for ZIPs downloaded from GH)
            $childItems = Get-ChildItem $tempDownloadDir -ea 0
            if (($childItems).Count -eq 1) {
                $subDir = Join-Path $tempDownloadDir $childItems
                if (Test-Path $subDir -PathType Container) {
                    $tempDownloadDir = $subDir
                }
            }
            # Look for the plugins directory
            $pluginDir = Get-Item "$tempDownloadDir\plugins" -ea 0
            if (!$pluginDir) { $pluginDir = $tempDownloadDir }

            # Delete files we don't want to copy
            Remove-Item "$pluginDir\README*" -Force -ea 0
            Remove-Item "$pluginDir\LICENSE*" -Force -ea 0

            Copy-Item "$pluginDir\*" $pluginsDir -Recurse
        }
        else {
            $packageArgs = @{
                packageName = ${Env:ChocolateyPackageName}
                url = $pluginUrl
                checksum = $pluginSha256
                checksumType = "sha256"
                fileFullPath = $pluginPath
                forceDownload = $true
            }
            Get-ChocolateyWebFile @packageArgs
        }
        VM-Assert-Path $pluginPath
    } catch {
        VM-Write-Log-Exception $_
    }
}

# Removes an IDA plugin file from the plugins directory
function VM-Uninstall-IDA-Plugin {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $pluginName # Example: capa_explorer.py
    )
    $pluginPath = Join-Path (VM-Get-IDA-Plugins-Dir) $pluginName
    Remove-Item $pluginPath -Recuse -Force -ea 0
}

# This functions returns $toolDir and $executablePath
function VM-Install-From-Zip {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $zipUrl,
        [Parameter(Mandatory=$false, Position=3)]
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
        [string] $arguments = "",
        [Parameter(Mandatory=$false)]
        [string] $executableName, # Executable name, needed if different from "$toolName.exe"
        [Parameter(Mandatory=$false)]
        [switch] $withoutBinFile, # Tool should not be installed as a bin file
        # Examples:
        # $powershellCommand = "Get-Content README.md"
        # $powershellCommand = "Import-Module module.ps1; Get-Help Main-Function"
        [Parameter(Mandatory=$false)]
        [string] $powershellCommand
    )
    try {
        $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

        # Remove files from previous zips for upgrade
        VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

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
        Install-ChocolateyZipPackage @packageArgs | Out-Null
        VM-Assert-Path $toolDir

        # If $innerFolder is set to $true, after unzipping there should be only one folder
        # GitHub ZIP files typically unzip to a single folder that contains the tools.
        if ($innerFolder) {
            $dirList = Get-ChildItem $toolDir -Directory
            $toolDir = Join-Path $toolDir $dirList[0].Name -Resolve
        }

        if ($powershellCommand) {
            $executablePath = $toolDir
            VM-Install-Shortcut -toolName $toolName -category $category -arguments $powershellCommand -executableDir $executablePath -powershell
        }
        elseif ($withoutBinFile) { # Used when tool does not have an associated executable
            if (-Not $executableName) { # Tool is located in $toolDir (c3.vm for example)
                $executablePath = $toolDir
            } else { # Tool is in a specific directory (pma-labs.vm for example)
                $executablePath = Join-Path $toolDir $executableName -Resolve
            }
            VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath
        }
        else {
            if (-Not $executableName) { $executableName = "$toolName.exe" }
            $executablePath = Join-Path $toolDir $executableName -Resolve
            VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments
            Install-BinFile -Name $toolName -Path $executablePath
        }
        return ,@($toolDir, $executablePath)
    } catch {
        VM-Write-Log-Exception $_
    }
}

function VM-Install-Node-Tool-From-Zip {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $category,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $zipUrl,
        [Parameter(Mandatory=$false, Position=3)]
        [string] $zipSha256,
        # node command such as "jailme.js -h -b list"
        [Parameter(Mandatory=$true)]
        [string] $command,
        [Parameter(Mandatory=$false)]
        [bool] $innerFolder=$true # Default to true as most node apps are GH repos (ZIP with inner folder)
    )
    # Install dependencies with npm when running shortcut as we ignore errors below
    $powershellCommand = "npm install; node $command"

    $toolDir = (VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $innerFolder -powershellCommand $powershellCommand)[0]

    # Prevent the following warning from failing the package: "npm WARN deprecated request@2.79.0"
    $ErrorActionPreference = 'Continue'
    # Get absolute path as npm may not be in PATH until Powershell is restarted
    $npmPath = Join-Path ${Env:ProgramFiles} "\nodejs\npm.cmd" -Resolve
    # Install tool dependencies with npm
    Set-Location $toolDir; & "$npmPath" install | Out-Null
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
        [string] $arguments = ""
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

        VM-Install-Shortcut -toolName $toolName -category $category -executableDir $toolDir -arguments $ps1Cmd -powershell

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

# Delete Desktop shortcuts
function VM-Remove-Desktop-Shortcut {
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $toolName
    )
    # Some shortcuts exist in Public and/or User profiles.
    ForEach ($location in @(${Env:Public}, ${Env:UserProfile})) {
        $desktopShortcut = Join-Path $location "Desktop\$toolName.lnk"
        if (Test-Path $desktopShortcut) {
            Remove-Item $desktopShortcut -Force -ea 0
        }
    }
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
        [string] $arguments = "",
        [Parameter(Mandatory=$false)]
        [string] $iconLocation
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

        # if no icon path provided, set the shortcut icon to be the executable's icon. For MSI files, attempt to get executable icon from the installer first.
        if (-Not $iconLocation) {
            if ($fileType -eq 'MSI') {
                $iconPath = VM-Get-MSIInstallerPathByProductName $toolName
                if ($iconPath) {
                    $files = Get-ChildItem -Path $iconPath -Filter "*.ico"
                    if ($files.Count -gt 0) {
                        $iconLocation = Join-Path $iconPath $files[0]
                    }
                }
                # If no icon found from MSI installation, fallback to using executablePath for iconLocation
                if (-Not $iconLocation) {
                    $iconLocation = $executablePath
                }
            }
        } else {
            # Not an MSI file, use executablePath for iconLocation
            $iconLocation = $executablePath
        }

        VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments -iconLocation $iconLocation
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
    # Remove tool shortcut
    VM-Remove-Tool-Shortcut $toolName $category

    # Remove tool files
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

    # Attempt to find and execute the uninstaller, may need to use wildcards
    # See: https://docs.chocolatey.org/en-us/create/functions/get-uninstallregistrykey
    [array]$key = Get-UninstallRegistryKey -SoftwareName $toolName
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
    VM-Write-Log "ERROR" "$msg`r`n$position_msg"
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
        [Parameter(Mandatory=$false, Position=3)]
        [string] $menuIcon,
        [Parameter(Mandatory=$false)]
        [ValidateSet("file", "directory")]
        [string] $type="file",
        [Parameter(Mandatory=$false)]
        [string] $extension,
        [Parameter(Mandatory=$false)]
        [switch] $background
    )
    try {
        if ($extension) {
          $key = "SystemFileAssociations\$extension"
        } else {
          # Determine if file or directory should show item in right-click menu
          if ($type -eq "file") {
              $key = "*"
          } else {
              $key = "Directory"
              if ($background) {
                $key += "\Background"
              }
          }
        }
        $key_path = "HKCR:\$key\shell\$menuKey"

        # Check and map "HKCR" to correct drive
        if (-NOT (Test-Path -path 'HKCR:')) {
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
        }

        # Add right-click menu display name
        if (-NOT (Test-Path -LiteralPath $key_path)) {
            New-Item -Path $key_path -Force | Out-Null
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
        [Parameter(Mandatory=$false)]
        [ValidateSet("file", "directory")]
        [string] $type="file",
        [Parameter(Mandatory=$false)]
        [string] $extension,
        [Parameter(Mandatory=$false)]
        [switch] $background
    )
    try {
        if ($extension) {
          $key = "SystemFileAssociations\$extension"
        } else {
          # Determine if file or directory should show item in right-click menu
          if ($type -eq "file") {
              $key = "*"
          } else {
              $key = "Directory"
              if ($background) {
                $key += "\Background"
              }
          }
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

# Add associations to the file extension key
function VM-Set-Open-With-Association {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $executablePath,
        [Parameter(Mandatory = $true)]
        [string] $extension
    )
    try {
        # Extract the executable name without path or extension
        $exeName = [System.IO.Path]::GetFileNameWithoutExtension($executablePath)

        ForEach ($hive in @("HKCU:", "HKLM:")) {
            # Create the 'command' key and its default value
            $commandKey = "${hive}\Software\Classes\${exeName}_auto_file\shell\open\command"
            New-Item -Path $commandKey -Force
            New-ItemProperty -Path $commandKey -Name '(Default)' -Value "`"$executablePath`" `"%1`""

            # Create/update the file extension key
            $extKey = "${hive}\Software\Classes\$extension"
            New-Item -Path $extKey -Force
            New-ItemProperty -Path $extKey -Name '(Default)' -Value "${exeName}_auto_file"

            # Add to OpenWithProgids for visibility in "Open with..." menu
            if (Get-ItemProperty -Path $extKey -Name 'OpenWithProgids' -ErrorAction Ignore) {
                # If OpenWithProgids exists, update it
                $existingProgIds = (Get-ItemProperty -Path $extKey -Name 'OpenWithProgids').OpenWithProgids
                $newProgIds = "$existingProgIds ${exeName}_auto_file" | Select-Object -Unique # Ensure unique values
                Set-ItemProperty -Path $extKey -Name 'OpenWithProgids' -Value $newProgIds -PropertyType ExpandString
            } else {
                # If OpenWithProgids doesn't exist, create it
                New-ItemProperty -Path $extKey -Name 'OpenWithProgids' -Value "${exeName}_auto_file" -PropertyType ExpandString
            }
        }
    } catch {
        VM-Write-Log "ERROR" "Failed to add $exeName as file association. Error: $_"
    }
}

# Remove associations from the file extension key
function VM-Remove-Open-With-Association {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $exeName,
        [Parameter(Mandatory = $true)]
        [string] $extension
    )
    ForEach ($hive in @("HKCU:", "HKLM:")) {
        $extKey = "${hive}\Software\Classes\$extension"

        # Check if the key exists before attempting removal
        if (Test-Path $extKey) {
            $expectedDefault = "${exeName}_auto_file"

            # Remove the default value if it matches
            $currentDefault = Get-ItemPropertyValue -Path $extKey -Name '(Default)' -ErrorAction SilentlyContinue
            if ($currentDefault -and $currentDefault -eq $expectedDefault) {
                New-ItemProperty -Path $extKey -Name '(Default)' -Value "" | Out-Null
            }

            # Remove from OpenWithProgids if present
            if ((Get-ItemProperty -Path $extKey -Name 'OpenWithProgids' -ErrorAction Ignore).OpenWithProgids -contains $expectedDefault) {
                $newProgIds = (Get-ItemProperty -Path $extKey -Name 'OpenWithProgids').OpenWithProgids -split ' ' | Where-Object { $_ -ne $expectedDefault }
                Set-ItemProperty -Path $extKey -Name 'OpenWithProgids' -Value ($newProgIds -join ' ')
            }
        }

        # Remove the 'command' key and the auto_file key
        $commandKey = "${hive}\Software\Classes\${exeName}_auto_file\shell\open\command"
        $autoFileKey = "${hive}\Software\Classes\${exeName}_auto_file"
        Remove-Item -Path $commandKey,$autoFileKey -Recurse -ErrorAction SilentlyContinue
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
RAW_TOOLS_DIR: ${Env:RAW_TOOLS_DIR}
"@

    VM-Write-Log "INFO" "$($survey -f $osInfo, $memInfo, $diskInfo, $avInfoFormatted, $psInfo, $psInfoClr, $chocoInfo, $boxstarerInfo, $installedPackages, $envVars)"
}

function VM-Remove-Appx-Package {
# Function for removing Appx Packages
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$appName
    )

    try {
        # Check if the app is installed using wildcard pattern
        $installedPackages = Get-AppxPackage | Where-Object { $_.Name -like $appName }

        if ($installedPackages) {
            foreach ($installedPackage in $installedPackages) {
                try {
                    $packageFullName = $installedPackage.PackageFullName
                    Remove-AppxPackage -Package $packageFullName -ErrorAction SilentlyContinue
                    VM-Write-Log "INFO" "$packageFullName removed"
                }
                catch {
                    VM-Write-Log-Exception $_
                }
            }
        } else {
            VM-Write-Log "WARN" "`tInstalled packages matching pattern '$appName' not found on the system."
        }

        # Check if the app is provisioned using wildcard pattern
        $provisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $appName } -ErrorAction SilentlyContinue

        if ($provisionedPackages) {
            foreach ($provisionedPackage in $provisionedPackages) {
                try {
                    Remove-AppxProvisionedPackage -PackageName $provisionedPackage.PackageName -Online -ErrorAction SilentlyContinue
                    VM-Write-Log "INFO" $("`tProvisioned package " + $provisionedPackage.PackageName + " removed")
                }
                catch {
                    VM-Write-Log-Exception $_
                }
            }
        } else {
            VM-Write-Log "WARN" "`tProvisioned packages matching pattern '$appName' not found on the system."
        }
    } catch {
        VM-Write-Log "ERROR" "`tAn error occurred while removing packages matching pattern '$appName'. Error: $_"
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
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

        if ($service) {
            Set-Service -Name $service.Name -StartupType Manual
            VM-Write-Log "INFO" "Service $serviceName has been disabled."
        } else {
            VM-Write-Log "WARN" "Service $serviceName not found."
        }
    } catch {
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
            VM-Write-Log "INFO" "Scheduled task '$name' has been disabled."
        } else {
            VM-Write-Log "ERROR" "Scheduled task '$name' not found."
        }

    } catch {
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
        } elseif ($type -eq "Binary") {
            $validatedData = [byte[]]::new(($data -split '(.{2})' | Where-Object { $_ -match '..' } | ForEach-Object { [convert]::ToByte($_, 16) }))
        } else {
            $validatedData = $data
        }

        # check if path exists. If not, create the path for the registry value
        if (!(Test-Path -Path $path)) {
            # Create the registry key
            New-Item -Path $path -Force | Out-Null
            VM-Write-Log "INFO" "Registry key created: $path"
        } else {
            VM-Write-Log "WARN" "Registry key already exists: $path"
        }

        Set-ItemProperty -Path $path -Name $value -Value $validatedData -Type $type -Force | Out-Null
        VM-Write-Log "INFO" "$name has been successful"
    } catch {
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
                VM-Write-Log "INFO" "$name has been successfully removed."
            } else {
                VM-Write-Log "WARN" "$path does not exist."
            }
        } elseif ($type -eq "dir") {
            if (Test-Path -Path $path -PathType Container) {
                Remove-Item -Path $path -Recurse -Force
                VM-Write-Log "INFO" "$name has been successfully removed."
            } else {
                VM-Write-Log "WARN" "$path does not exist."
            }
        }
    } catch {
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
        VM-Write-Log "INFO" "Executing commands for '$name':"
        foreach ($cmd in $cmds) {
            Start-Process powershell -ArgumentList "-WindowStyle","Hidden","-Command",$cmd -Wait
        }
        VM-Write-Log "INFO" "`tAll commands for '$name' have been executed successfully."
    } catch {
        VM-Write-Log "ERROR" "`tAn error occurred while executing commands for '$name'. Error: $_"
    }
}

function VM-Configure-Prompts {
    # $Env:VMname must be set in the install script
    try {
        # Set PowerShell prompt
        $psprompt = @"
        function prompt {
            Write-Host (`$Env:VMname + " " + `$(Get-Date)) -ForegroundColor Green
            Write-Host ("PS " + `$(Get-Location) + " >") -NoNewLine -ForegroundColor White
            return " "
        }
"@

        # Ensure profile file exists and append new content to it, not overwriting old content
        if (!(Test-Path $profile)) {
            New-Item -ItemType File -Path $profile -Force | Out-Null
        }
        Add-Content -Path $profile -Value $psprompt

        # Set cmd prompt
        ## Configure the command
        $VMname = $Env:VMname -replace ' ', '' # setx command cannot have spaces
        $command = "cmd /c 'setx PROMPT $VMname`$S`$d`$s`$t`$_`$p$+`$g'"
        ## Convert to base64
        $base64 = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
        ## Run command
        Invoke-Expression ([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64))) | Out-Null

        VM-Write-Log "INFO" "Timestamps added to cmd prompt and PowerShell"
    } catch {
        VM-Write-Log-Exception $_
    }

}

function VM-Configure-PS-Logging {
    if ($PSVersionTable -And $PSVersionTable.PSVersion.Major -ge 5) {
        try {
            VM-Write-Log "INFO" "Enabling PowerShell Script Block Logging"

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
            VM-Write-Log "INFO" "PowerShell transcripts will be saved to the desktop."
        } catch {
            VM-Write-Log-Exception $_
        }
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
        VM-Assert-Path $configFile
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

        # Process the tasks
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
    } catch {
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

function VM-Refresh-Desktop {
    try {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Shell {
    [DllImport("Shell32.dll")]
    public static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
}
"@
        $SHCNE_ASSOCCHANGED = 0x08000000
        $SHCNF_IDLIST = 0
        [void][Shell]::SHChangeNotify($SHCNE_ASSOCCHANGED, $SHCNF_IDLIST, [IntPtr]::Zero, [IntPtr]::Zero)
    } catch {
        VM-Write-Log-Exception $_
    }
}

# Sort Desktop icons by item type using WScript.Shell to replicate the manual steps
# This is written in a way to that ensures things will be sorted properly for multiple possible states.
function VM-Sort-Desktop-Icons {
    VM-Write-Log "INFO" "Sorting Desktop icons"
    # toggleDesktop sets the focus to the desktop for regular Powershell, but not fully for Windows-Terminal Powershell.
    (New-Object -ComObject Shell.Application).toggleDesktop();
    Start-Sleep -Milliseconds 100;
    # Start Windows Run
    # This + (Alt + F4) is needed to ensure focus is set to the desktop properly to perform the other actions; Needed for Windows-Terminal Powershell.
    $shell = New-Object -ComObject Shell.Application;
    $shell.FileRun();
    Start-Sleep -Milliseconds 200;
    $objShell = New-Object -ComObject WScript.Shell;
    # Close out of "Run" to get focus on desktop.
    $objShell.SendKeys("%{F4}");    # Alt + F4
    Start-Sleep -Milliseconds 100;
    # Sort by Name then Sort by Item Type using a way that works for a variety of possible states that the desktop could be in.
    $objShell.SendKeys("^a{F5}+{F10}on+{F10}oi");   # 'ctrl + a' -> 'F5' -> 'Shift + F10' -> 'o' -> 'n' -> 'Shift + F10' -> 'o' -> 'i'
    Start-Sleep -Milliseconds 100;
}

# Usage example:
# VM-Remove-DesktopFiles -excludeFolders "Labs", "Demos" -excludeFiles "MICROSOFT Windows 10 License Terms.txt", "Labs.zip"
# The function is run against both the Current User and 'Public' desktops due to some cases where desktop icons showing on
# Current user Desktop that are only located in Public/Desktop.
function VM-Remove-DesktopFiles {
    param (
        [Parameter(Mandatory=$false)]
        [string[]]$excludeFolders,
        [Parameter(Mandatory=$false)]
        [string[]]$excludeFiles
    )
    # Ensure that the "Recycle Bin" folder, the "PS_Transcripts" folder,
    # and the Tools folder (if located on the desktop) are not deleted.
    $defaultExcludedFolders = @("Recycle Bin", "PS_Transcripts", ${Env:TOOL_LIST_DIR})
    # Ensure that the "fakenet_logs" shortcut is not deleted.
    $defaultExcludedFiles = @("fakenet_logs.lnk")
    $excludeFolders = $excludeFolders + $defaultExcludedFolders
    $excludeFiles = $excludeFiles  + $defaultExcludedFiles
    $userAccounts = @(
        [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop), # Current user's desktop
        [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory) # Public desktop
    )
    foreach ($userDesktopPath in $userAccounts) {
        # Use -Force to get hidden files (such as desktop.ini)
        Get-ChildItem -Path $userDesktopPath -Force | ForEach-Object {
            $item = $_
            if ($item.PSIsContainer -and ($item.Name -notin $excludeFolders -and $item.FullName -notin $excludeFolders)) {
                VM-Write-Log "INFO" "Deleting folder: $($item.FullName)"
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction SilentlyContinue
            }
            elseif ($item.PSIsContainer -eq $false -and ($item.Name -notin $excludeFiles -and $item.FullName -notin $excludeFiles)) {
                VM-Write-Log "INFO" "Deleting file: $($item.FullName)"
                Remove-Item -Path $item.FullName -Force -ErrorAction SilentlyContinue
            }
            if(!$?){
                VM-Write-Log "ERROR" "`tFailed to delete"
            }
        }
    }
}

function VM-Clear-TempAndCache {
    $temp = [System.IO.Path]::GetTempPath()
    $chocolatey = Join-Path $temp 'chocolatey'
    $localAppDataPath = [System.Environment]::GetFolderPath('LocalApplicationData')
    $commonAppDataPath = [System.Environment]::GetFolderPath('CommonApplicationData')
    $nugetCache = Join-Path $localAppDataPath 'NuGet\cache'
    $packageCache1 = Join-Path $localAppDataPath 'Package` Cache'
    $packageCache2 = Join-Path $commonAppDataPath 'Package` Cache'

    $command1 = 'cmd /c del /Q /S ' + $temp
    $command2 = 'cmd /c rmdir /Q /S ' + $chocolatey + ' ' + $nugetCache + ' ' + $packageCache1 + ' ' + $packageCache2

    Invoke-Expression $command1
    Invoke-Expression $command2
}

# SDelete can take a bit of time (~2+ mins) and requires sysinternals to be installed
function VM-Clear-FreeSpace {
    VM-Write-Log "INFO" "Performing SDelete to optimize disk."
    $sdeletePath = Get-Command -Name "sdelete.exe" -ErrorAction SilentlyContinue
    if ($sdeletePath) {
        Invoke-Expression 'cmd /c sdelete -accepteula -nobanner -z C:'
    }
    else {
        VM-Write-Log "WARN" "SDelete not found. Ensure sysinternals.vm is installed and SDelete is in the system's PATH before running VM-Clear-FreeSpace to free space."
    }
}

function VM-Clean-Up {
    param (
        [Parameter(Mandatory=$false)]
        [string[]]$excludeFolders,
        [Parameter(Mandatory=$false)]
        [string[]]$excludeFiles
    )
    Write-Host "[+] Removing Desktop Files..." -ForegroundColor Green
    VM-Remove-DesktopFiles -excludeFolders $excludeFolders -excludeFiles $excludeFiles

    Write-Host "[+] Sorting Desktop Icons..." -ForegroundColor Green
    VM-Sort-Desktop-Icons

    Write-Host "[+] Clearing Temp and Cache..." -ForegroundColor Green
    VM-Clear-TempAndCache

    Write-Host "[+] Clearing Recycle Bin" -ForegroundColor Green
    Clear-RecycleBin -Force -ErrorAction Continue

    Write-Host "[+] Running Disk Cleanup..." -ForegroundColor Green
    VM-Write-Log "INFO" "Performing Disk Cleanup."
    Invoke-Expression 'cmd /c cleanmgr.exe /AUTOCLEAN'

    Write-Host "[+] Clearing up free space. This may take a few minutes..." -ForegroundColor Green
    VM-Clear-FreeSpace

    Write-Host "[+] Clear PowerShell History" -ForegroundColor Green
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ea 0
}

function VM-Add-To-Path {
    param (
        [string]$pathToAdd
    )

    # Function to normalize a path and handle exceptions
    function NormalizePath {
        param (
            [string]$path
        )
        try {
            return [System.IO.Path]::GetFullPath($path)
        }
        catch {
            return $null
        }
    }

    # Ensure the path to add is not null or empty
    if ([string]::IsNullOrWhiteSpace($pathToAdd)) {
        VM-Write-Log "ERROR" "Tried to add empty path to the Path"
        return
    }

    # Get the Machine Path environment variable and split it into an array
    $currentPaths = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -split [IO.Path]::PathSeparator

    # Normalize the input path
    $normalizedPathToAdd = NormalizePath $pathToAdd
    if (-not $normalizedPathToAdd) {
        VM-Write-Log "ERROR" "Tried to add invalid path to the Path: $pathToAdd"
        return
    }

    # Check if the path already exists in the array
    $pathExists = $false
    foreach ($path in $currentPaths) {
        $normalizedPath = NormalizePath $path
        if ($normalizedPath -and $normalizedPath -eq $normalizedPathToAdd) {
            $pathExists = $true
            break
        }
    }

    # Add the new path if it doesn't exist
    if (-not $pathExists) {
        $newPath = ($currentPaths + $pathToAdd) -join [IO.Path]::PathSeparator
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    }
}

# Useful for getting icons for tools installed from an MSI file
function VM-Get-MSIInstallerPathByProductName {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$ProductName    # Name of the installed program
    )

    try {
        # Get a list of all installed MSI products
        $installedProducts = Get-CimInstance -Class Win32_Product | Where-Object { $_.Name -like $ProductName }

        if (-not $installedProducts) {
            VM-Write-Log "WARN" "No product found with name like '$ProductName'"
            return
        }

        foreach ($product in $installedProducts) {
            # Retrieve the GUID of the installer
            $productCode = $product.IdentifyingNumber

            # Construct the likely path to the installer cache
            $installerPath = Join-Path -Path 'C:\Windows\Installer' -ChildPath $productCode

            # Check if the constructed path exists
            if (Test-Path -Path $installerPath) {
                return $installerPath
            } else {
                VM-Write-Log "WARN" "Installer cache folder not found for product '$ProductName'"
            }
        }
    } catch {
        VM-Write-Log-Exception $_ "An error occurred: $_"
    }
}

function VM-Pip-Install {
    param (
        [string]$package
    )
    # Create output file to log python module installation details
    $outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}

    Invoke-Expression "py -3.10 -m pip install $package --disable-pip-version-check 2>&1 >> $outputFile"
}
