$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'setdllcharacteristics'
$category = 'PE'

VM-Uninstall $toolName $category
