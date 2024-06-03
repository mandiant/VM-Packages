$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = "diaphora_plugin.py"
VM-Uninstall-IDA-Plugin -pluginName $pluginName
