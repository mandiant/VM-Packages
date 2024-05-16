$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg' -Resolve
$pluginPath = Join-Path $toolDir 'OllyDumpEx_Od11.dll' -Resolve
Remove-Item $pluginPath -Force -ea 0
