$ErrorActionPreference = 'Continue'

$toolName = 'ScreenToGif'
$category = 'Utilities'

$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

# Remove shortcut file
$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0

# Uninstall binary
Uninstall-BinFile -Name $toolName
