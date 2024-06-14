$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Windows Terminal'
  $category = 'Productivity Tools'
  $executableName = "wt.exe"

  $zipUrl = 'https://github.com/microsoft/terminal/releases/download/v1.19.10573.0/Microsoft.WindowsTerminal_1.19.10573.0_x64.zip'
  $zipSha256 = 'F756A41FA2DBEE274334CB49D93A84CB29E5DF0A2446FC79BF7ED9FFE8B49FFB'

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
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  # GitHub ZIP files typically unzip to a single folder that contains the tools.
  $dirList = Get-ChildItem $toolDir -Directory
  $toolDir = Join-Path $toolDir $dirList[0].Name -Resolve
  $workingDir = Join-Path ${Env:UserProfile} "Desktop"
  $arguments = "-p `"Command Prompt`" -d `"$workingDir`""   # Working directory doesn't work for admin shortcuts, so use -d flag for it.
  $executablePath = Join-Path $toolDir $executableName -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -arguments $arguments -runAsAdmin

  # Create a basic settings.json file so Windows Terminal always opens with elevated privileges
  $settingsPath = "${Env:LOCALAPPDATA}\Microsoft\Windows Terminal\settings.json"
  $settingsFileDir = Split-Path $settingsPath
  New-Item -ItemType Directory -Force -Path $settingsFileDir
  $defaultSettings = @"
{
  "`$schema": "https://aka.ms/terminal-settings-schema-v1.1",
  "defaultProfile": "Command Prompt",
  "profiles": {
    "defaults": {
      "elevate": true
    }
  }
}
"@
  $defaultSettings | Out-File $settingsPath -Encoding Utf8

  # Add right click for Windows Terminal
  $command = "`"$executablePath`" -p `"Command Prompt`" -d `"%V`""
  $label = "Open Terminal here"
  $icon = "$executablePath"
  VM-Add-To-Right-Click-Menu -menuKey $toolName -menuLabel $label -command $command -menuIcon $icon -type "directory" -background

  # Set windows terminal as the default terminal (effective only when OS Build >= 19045.3031)
  $registryPath = 'HKCU:\Console\%%Startup'
  New-Item $registryPath -Force | Out-Null
  Set-ItemProperty $registryPath -Name "DelegationConsole" -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}" -Force | Out-Null
  Set-ItemProperty $registryPath -Name "DelegationTerminal" -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}" -Force | Out-Null
} catch {
  VM-Write-Log-Exception $_
}
