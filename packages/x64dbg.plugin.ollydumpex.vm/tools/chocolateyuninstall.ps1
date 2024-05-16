$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x32\plugins'
$pluginPath = Join-Path $toolDir 'OllyDumpEx_X64Dbg.dp32'
Remove-Item $pluginPath -Force -ea 0

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release\x64\plugins'
$pluginPath = Join-Path $toolDir 'OllyDumpEx_X64Dbg.dp64'
Remove-Item $pluginPath -Force -ea 0