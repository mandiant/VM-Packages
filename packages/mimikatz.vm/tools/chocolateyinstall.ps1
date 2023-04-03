$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {


  $toolName = 'mimikatz'
  $category = 'Password Attacks'


  $ErrorActionPreference = 'Stop'
  Import-Module vm.common -Force -DisableNameChecking
  $name = "Mimikatz"
  $path = Join-Path ${Env:TOOL_LIST_DIR} 'Password Attacks'

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolsDir = Join-Path "${Env:RAW_TOOLS_DIR}" $name
  if (-Not (Test-Path $toolsDir)) {
    New-Item -Path $toolsDir -ItemType Directory -Force | Out-Null
  }

  $url = "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.7z"
  $checksum = "1F2338D7B628374139D373AF383A1BDEC1A16B43CED015849C6BE4E4D90CC2C3"

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolsDir
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
  }

  Install-ChocolateyZipPackage @packageArgs

  $shortcut = Join-Path $path "mimikatz.x86.lnk"
  $target = Join-Path (Join-Path $toolsDir "Win32") "mimikatz.exe"
  $target_cmd = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $target_args = '/K "' + $target + '"'
  $target_icon = $target_cmd
  $target_dir = Join-Path ${Env:UserProfile} "Desktop"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_cmd -Arguments $target_args -WorkingDirectory $target_dir -IconLocation $target_icon
  Install-BinFile -Name "mimikatz.x86" -Path $target

  $shortcut = Join-Path $path "mimikatz.x64.lnk"
  $target = Join-Path (Join-Path $toolsDir "x64") "mimikatz.exe"
  $target_cmd = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $target_args = '/K "' + $target + '"'
  $target_icon = $target_cmd
  $target_dir = Join-Path ${Env:UserProfile} "Desktop"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $target_cmd -Arguments $target_args -WorkingDirectory $target_dir -IconLocation $target_icon
  Install-BinFile -Name "mimikatz.x64" -Path $target
}
catch{
  Write-Host "Mimikatz failed to install:"
  Write-Host $_
}