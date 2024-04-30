$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'dereferencing.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

