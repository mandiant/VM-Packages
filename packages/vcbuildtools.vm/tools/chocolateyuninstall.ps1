$ErrorActionPreference = 'Continue'
$category = 'Utilities'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
$shortcut = Join-Path $shortcutDir 'Microsoft Visual C++ Build Tools.lnk'
Remove-Item $shortcut -Force -ea 0 | Out-Null
