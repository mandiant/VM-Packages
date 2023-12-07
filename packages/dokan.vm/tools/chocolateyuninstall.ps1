$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dokan'
$category = 'Utilities'

VM-Uninstall $toolName $category