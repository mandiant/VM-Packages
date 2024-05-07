$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'comida.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName

