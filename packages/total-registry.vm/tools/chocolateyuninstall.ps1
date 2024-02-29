$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TotalReg'
$category = 'Utilities'

VM-Uninstall $toolName $category
