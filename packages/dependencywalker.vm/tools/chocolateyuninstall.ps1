$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dependency Walker'
$category = 'PE'

VM-Uninstall $toolName $category
