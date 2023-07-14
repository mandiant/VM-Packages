$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RouteSixtySink'
$category = 'dotNet'

VM-Uninstall $toolName $category
