$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginsDir = VM-Get-IDA-Plugins-Dir

# Uninstall plugin
$pluginPath = Join-Path $pluginsDir "capa_explorer.py"
Remove-Item $pluginPath

# Delete capa rules
$rulesDir = Join-Path $pluginsDir "capa-rules-6.1.0"
Remove-Item $rulesDir

# Delete registry information
Remove-Item 'HKCU:\SOFTWARE\IDAPython\IDA-Settings\capa'
