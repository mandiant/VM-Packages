# Setting this to "Stop". Functions should properly handle errors or throw to calling function.
$ErrorActionPreference = 'Stop'


# ################################################################################################ #
# \ \ ---------------------------------------- N O T E ---------------------------------------- / /
#
#     Below are general helper functions for any VM package to use
#
# ################################################################################################ #

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

# This functions returns $executablePath and $toolDir (outputed by Install-ChocolateyZipPackage)
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

# This functions returns $executablePath and $toolDir (outputed by Install-ChocolateyZipPackage)
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
    [bool] $innerFolder=$false # subfolder in zip with the app files
  )
  try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

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

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    if ($consoleApp) {
      $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
      $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
      $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath
    } else {
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    }
    VM-Assert-Path $shortcut

    Install-BinFile -Name $toolName -Path $executablePath
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
    [bool] $consoleApp=$false
  )
  try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

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

    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    if ($consoleApp) {
      $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
      $executableDir  = Join-Path ${Env:UserProfile} "Desktop" -Resolve
      $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath
    } else {
      Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    }
    VM-Assert-Path $shortcut

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

    $shortcut = Join-Path $shortcutDir "$toolName.ps1.lnk"
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
  # Attempt to find and execute the uninstaller
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
    [string] $type
  )
  try {
    # Determine if file or directory should show item in right-click menu
    if ($type -eq "file") {
      $key = "*"
    } else {
      $key = "directory"
    }

    # Check and map "HKCR" to correct drive
    if (-NOT (Test-Path -path 'HKCR:')) {
      New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }

    # Add right-click menu display name
    if (-NOT (Test-Path -LiteralPath "HKCR:\$key\shell\$menuKey")) {
      New-Item -Path "HKCR:\$key\shell\$menuKey" | Out-Null
    }
    Set-ItemProperty -LiteralPath "HKCR:\$key\shell\$menuKey" -Name '(Default)' -Value "$menuLabel" -Type String

    # Add command to run when executed from right-click menu
    if(-NOT (Test-Path -LiteralPath "HKCR:\$key\shell\$menuKey\command")) {
      New-Item -Path "HKCR:\$key\shell\$menuKey\command" | Out-Null
    }
    Set-ItemProperty -LiteralPath "HKCR:\$key\shell\$menuKey\command" -Name '(Default)' -Value $command -Type String
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

    # Check and map "HKCR" to correct drive
    if (-NOT (Test-Path -path 'HKCR:')) {
      New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }

    # Remove right-click menu settings from registry
    if (Test-Path -LiteralPath "HKCR:\$key\shell\$menuKey") {
      Remove-Item -LiteralPath "HKCR:\$key\shell\$menuKey" -Recurse
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

VM Chocolatey Version
-----
{5}

VM Boxstarter Version
-----
{6}
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

  $osInfo = (Get-WMIObject win32_operatingsystem) | Select-Object Version, BuildNumber, OSArchitecture, ServicePackMajorVersion, Caption | Out-String
  $memInfo = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1mb | Out-String
  $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk | Out-String
  $psInfo = $PSVersionTable.PSVersion
  $chocoInfo = choco --version
  $boxstarerInfo = choco list --local-only | Select-String -Pattern "Boxstarter" | Out-String

  # Decode bit flags by masking the relevant bits, then converting
  $avInfo = Get-CimInstance -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ComputerName ${Env:computername}
  $avInfoFormatted = @"
DisplayName: $($avInfo.displayName)
ProductOwner: $([ProductOwner]([UInt32]$avInfo.productState -band [ProductFlags]::ProductOwner))
ProductState: $([ProductState]([UInt32]$avInfo.productState -band [ProductFlags]::ProductState))
SignatureStatus: $([SignatureStatus]([UInt32]$avInfo.productState -band [ProductFlags]::SignatureStatus))
"@

  VM-Write-Log "INFO" $($survey -f $osInfo, $memInfo, $diskInfo, $avInfoFormatted, $psInfo, $chocoInfo, $boxstarerInfo)
}

