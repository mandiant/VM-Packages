$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginName = 'delphihelper.py'
VM-Uninstall-IDA-Plugin -pluginName $pluginName
