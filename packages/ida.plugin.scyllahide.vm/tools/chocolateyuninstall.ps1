$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$installDir = Join-Path ${Env:ProgramFiles} "ScyllaHide"               -Resolve
$pluginsDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 8.3\plugins" -Resolve
$pluginPath = Join-Path $pluginsDir         "HookLibraryx64.dll"       -Resolve
$configPath = Join-Path $pluginsDir         "scylla_hide.ini"          -Resolve

Remove-Item $installDir -Recurse
Remove-Item $pluginPath
Remove-Item $configPath