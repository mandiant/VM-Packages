$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Exeinfo PE'
$category = 'Utilities'

VM-Uninstall $toolName $category
