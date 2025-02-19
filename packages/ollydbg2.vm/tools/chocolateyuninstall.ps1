$ErrorActionPreference = 'Continue'
$toolName = 'OllyDbg2'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
$shortcut = Join-Path $shortcutDir "$toolName.lnk"
Remove-Item $shortcut -Force -ea 0 | Out-Null
Uninstall-BinFile -Name 'ollydbg2'
