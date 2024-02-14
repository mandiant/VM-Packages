$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Microsoft Windows Terminal'
$shortcutDir = ${Env:RAW_TOOLS_DIR}
$shortcut = Join-Path $shortcutDir "$toolName.lnk"

Remove-Item $shortcut -Force -ea 0 | Out-Null