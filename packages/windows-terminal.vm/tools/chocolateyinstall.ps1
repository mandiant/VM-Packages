$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Windows Terminal'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $executableName = "wt.exe"

  $zipUrl = 'https://github.com/microsoft/terminal/releases/download/v1.22.11751.0/Microsoft.WindowsTerminal_1.22.11751.0_x64.zip'
  $zipSha256 = 'f8c4aa0802b0a8c2fa2acd260fbc437ceae05bb9be4efc0d1da4d013b74b35c9'

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

  # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
