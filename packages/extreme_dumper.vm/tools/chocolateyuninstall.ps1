$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ExtremeDumper'
$category = 'dotNet'

VM-Uninstall $toolName $category
