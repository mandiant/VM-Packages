$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Malcode Analyst Pack'
  $category = 'Utilities'

  $url = 'http://sandsprite.com/CodeStuff/map_setup.exe'
  $checksum = '285e4842d5aef3023594fbc2de4972c6890331c641478bdce67ecf4797c1e1d1'

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=`"$toolDir`""
  }
  Install-ChocolateyPackage @packageArgs
  VM-Assert-Path $toolDir

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}