$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'de4dot'
$category = 'dotNet'

VM-Uninstall $toolName $category
