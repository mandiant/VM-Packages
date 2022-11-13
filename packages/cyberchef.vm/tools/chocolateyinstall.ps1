$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cyberchef'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v9.49.0/CyberChef_v9.49.0.zip'
    checksum      = '410f98fb8fc0e6d8eaf4bfa5c85422bf990f9e42df7e0859160d08fceb2c6570'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $htmlPath = Join-Path $toolDir "CyberChef_v9.49.0.html" -Resolve
  $shortcut = Join-Path $shortcutDir "CyberChef.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $htmlPath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}