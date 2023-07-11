$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
