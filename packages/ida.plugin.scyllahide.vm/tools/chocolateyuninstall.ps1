$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

# Remove the plugin
$pluginsDir = "$Env:APPDATA\Hex-Rays\IDA Pro\plugins"
$pluginPath = Join-Path $pluginsDir "HookLibraryx64.dll" -Resolve
$configPath = Join-Path $pluginsDir "scylla_hide.ini" -Resolve
Remove-Item $pluginPath
Remove-Item $configPath