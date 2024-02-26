$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $category = 'Productivity Tools'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $programFiles = ${Env:ProgramFiles(x86)}
  if (-Not ($programFiles)) {
    $programFiles = ${Env:ProgramFiles}
  }

  $toolDir = Join-Path $programFiles 'Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build' -Resolve
  $shortcut = Join-Path $shortcutDir 'Microsoft Visual C++ Build Tools.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
