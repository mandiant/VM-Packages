$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'ifl.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

