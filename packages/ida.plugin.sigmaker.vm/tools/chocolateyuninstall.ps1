$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginsDir = "$Env:APPDATA\Hex-Rays\IDA Pro\plugins"

# Uninstall plugin
$pluginPath = Join-Path $pluginsDir "SigMaker.dll"
Remove-Item $pluginPath -Force
