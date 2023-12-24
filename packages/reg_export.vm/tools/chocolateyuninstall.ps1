$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'reg_export'
$category = 'Utilities'

VM-Uninstall $toolName $category
