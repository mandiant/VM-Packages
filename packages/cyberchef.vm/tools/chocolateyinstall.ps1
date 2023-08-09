$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $category = 'Utilities'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'cyberchef'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.5.2/CyberChef_v10.5.2.zip'
    checksum      = 'a4d47a313d9e79d08775abfde18a08c32b50b4db8fa52261bfddbb785910d0ef'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $htmlPath = Join-Path $toolDir "CyberChef_v10.5.2.html" -Resolve
  $shortcut = Join-Path $shortcutDir "CyberChef.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $htmlPath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
