$ErrorActionPreference = 'Continue'

$toolName = '010Editor'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

# Remove shortcut file
$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0

# Uninstall binary
Uninstall-BinFile -Name $toolName
