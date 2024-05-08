$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'hashdb.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

