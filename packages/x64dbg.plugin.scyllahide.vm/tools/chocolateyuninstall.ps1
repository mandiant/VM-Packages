$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x32\plugins'
$pluginPath = Join-Path $toolDir 'ScyllaHideX64DBGPlugin.dp32'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'HookLibraryx86.dll'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'scylla_hide.ini'
Remove-Item $pluginPath -Force -ea 0

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x64\plugins'
$pluginPath = Join-Path $toolDir 'ScyllaHideX64DBGPlugin.dp64'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'HookLibraryx64.dll'
Remove-Item $pluginPath -Force -ea 0

$pluginPath = Join-Path $toolDir 'scylla_hide.ini'
Remove-Item $pluginPath -Force -ea 0