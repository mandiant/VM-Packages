$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'OllyDbg'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Debuggers'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://www.ollydbg.de/odbg110.zip'
    checksum      = '73B1770F28893DAB22196EB58D45EDE8DDF5444009960CCC0107D09881A7CD1E'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $executablePath = Join-Path $toolDir "ollydbg.exe" -Resolve

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  Install-BinFile -Name 'ollydbg' -Path $executablePath
} catch {
  VM-Write-Log-Exception $_
}