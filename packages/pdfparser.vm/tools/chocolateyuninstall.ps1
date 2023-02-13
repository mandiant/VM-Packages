$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "pdf-parser"
Remove-Item $toolDir -recurse -Force -ea 0
