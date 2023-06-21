$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
