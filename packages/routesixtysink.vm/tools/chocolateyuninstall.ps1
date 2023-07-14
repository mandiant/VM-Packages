$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RouteSixtySink'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
