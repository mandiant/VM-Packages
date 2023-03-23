$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cyberchef'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.0.0/CyberChef_v10.0.0.zip'
    checksum      = '13b04e580420ae3a97915372d1f4a7bdabef83f647a7d541428e2aeb83e15f09'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $htmlPath = Join-Path $toolDir "CyberChef_v10.0.0.html" -Resolve
  $shortcut = Join-Path $shortcutDir "CyberChef.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $htmlPath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}