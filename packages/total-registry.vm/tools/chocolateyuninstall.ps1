$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TotalReg'
$category = 'Registry'

VM-Uninstall $toolName $category
