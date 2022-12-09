$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'exeinfope'
$category = 'Utilities'

VM-Uninstall $toolName $category
