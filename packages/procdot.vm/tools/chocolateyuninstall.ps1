$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'procdot'
$category = 'Utilities'

VM-Uninstall $toolName $category
