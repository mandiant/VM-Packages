$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginsDir = VM-Get-IDA-Plugins-Dir

# Uninstall plugin
$pluginPath = Join-Path $pluginsDir "capa_explorer.py"
Remove-Item $pluginPath

# Delete capa rules
$rulesDir = Get-ChildItem "$pluginsDir\capa-rules-*"
Remove-Item $rulesDir -Recurse

# Delete registry information
Remove-Item 'HKCU:\SOFTWARE\IDAPython\IDA-Settings\capa'
