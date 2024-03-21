$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = 'Memory'

VM-Uninstall $toolName $category
