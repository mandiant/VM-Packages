$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'xray.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

