$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RouteSixtySink'
$category = 'Web Application'

VM-Uninstall $toolName $category
