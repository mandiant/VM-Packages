$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PMA-labs'
$category = 'Utilities'

VM-Uninstall $toolName $category
