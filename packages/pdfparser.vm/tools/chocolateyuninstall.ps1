$ErrorActionPreference = 'Continue'

$category = "PDF"
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "pdf-parser"
$toolName = "pdf-parser.py"
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
$shortcut = Join-Path $shortcutDir "${toolName}.lnk"

Remove-Item $toolDir -recurse -Force -ea 0
Remove-Item $shortcut -Force -ea 0