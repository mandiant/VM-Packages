$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PetitPotam'
$category = 'Exploitation'

VM-Uninstall $toolName $category
