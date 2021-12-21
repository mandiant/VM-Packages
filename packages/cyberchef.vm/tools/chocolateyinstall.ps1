$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cyberchef'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v9.32.3/CyberChef_v9.32.3.zip'
    checksum      = '465cf64bdd80cf99be72bedc9dccf7fcebaeace58d77ec62d71733c3e2ba404f'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $htmlPath = Join-Path $toolDir "CyberChef_v9.32.3.html" -Resolve
  $shortcut = Join-Path $shortcutDir "CyberChef.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $htmlPath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}