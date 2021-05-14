$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'peid'
$category = 'Utilities'

VM-Uninstall $toolName $category
