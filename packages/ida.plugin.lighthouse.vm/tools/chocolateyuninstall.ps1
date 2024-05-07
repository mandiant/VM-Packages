$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'lighthouse_plugin.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

