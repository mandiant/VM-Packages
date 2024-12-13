$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'xrefer.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName
