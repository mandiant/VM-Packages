$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginsDir = "$Env:APPDATA\Hex-Rays\IDA Pro\plugins"

# Uninstall plugin
$pluginPath = Join-Path $pluginsDir "comida.py"
Remove-Item $pluginPath -Force
