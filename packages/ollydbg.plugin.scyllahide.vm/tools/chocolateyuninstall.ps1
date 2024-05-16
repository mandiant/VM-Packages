$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg'
$pluginPath = Join-Path $toolDir 'ScyllaHideOlly1Plugin.dll'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'HookLibraryx86.dll'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'scylla_hide.ini'
Remove-Item $pluginPath -Force -ea 0