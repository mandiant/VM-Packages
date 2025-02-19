$ErrorActionPreference = 'Continue'

$toolName = 'x64dbg'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
$shortcut = Join-Path $shortcutDir "x32dbg.lnk"
Remove-Item $shortcut -Force -ea 0 | Out-Null
Uninstall-BinFile -Name 'x32dbg'

$shortcut = Join-Path $shortcutDir "x64dbg.lnk"
Remove-Item $shortcut -Force -ea 0 | Out-Null
Uninstall-BinFile -Name 'x64dbg'
