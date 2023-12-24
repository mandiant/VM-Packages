$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WMImplant'
$category = 'Command & Control'

VM-Uninstall $toolName $category
