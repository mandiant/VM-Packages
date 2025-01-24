$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginNames = @("hrtng.dll", "apilist.txt", "literal.txt")
ForEach ($pluginName in $pluginNames) {
  VM-Uninstall-IDA-Plugin -pluginName $pluginName
}
