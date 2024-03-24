$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginsDir = "$Env:APPDATA\Hex-Rays\IDA Pro\plugins"

# Uninstall plugin
$pluginFile = Join-Path $pluginsDir "lighthouse_plugin.py"
$pluginDir  = Join-Path $pluginsDir "lighthouse"
Remove-Item $pluginFile
Remove-Item $pluginDir -Recurse

# Uninstall the code coverage binaries
$toolName = "CodeCoverage"
$toolDir  = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
Remove-Item $toolDir -Recurse
