$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cyberchef'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v9.46.5/CyberChef_v9.46.5.zip'
    checksum      = '990BB3E59ECE04CDFC016D619AE4E84E2EE5F17D7618AF7763388CC9D86FC1A0'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $htmlPath = Join-Path $toolDir "CyberChef_v9.46.5.html" -Resolve
  $shortcut = Join-Path $shortcutDir "CyberChef.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $htmlPath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}