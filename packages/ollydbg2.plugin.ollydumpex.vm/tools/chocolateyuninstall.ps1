$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg2' -Resolve
$pluginPath = Join-Path $toolDir 'OllyDumpEx_Od20.dll' -Resolve
Remove-Item $pluginPath -Force -ea 0
