$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'SigMaker9_64.dll'
VM-Uninstall-IDA-Plugin -pluginName $pluginName
