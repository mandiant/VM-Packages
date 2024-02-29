$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'reg_export'
$category = 'Registry'

VM-Uninstall $toolName $category
