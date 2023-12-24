$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GarbageMan'
$category = 'dotNet'

VM-Uninstall $toolName $category
