$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerCat'
$category = 'Utilities'

VM-Uninstall $toolName $category
