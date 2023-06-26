$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JuicyPotato'
$category = 'Exploitation'

VM-Uninstall $toolName $category
