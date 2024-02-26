$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Microsoft Windows Terminal'
$category = 'Productivity Tools'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
$shortcut = Join-Path $shortcutDir "$toolName.lnk"

Remove-Item $shortcut -Force -ea 0 | Out-Null