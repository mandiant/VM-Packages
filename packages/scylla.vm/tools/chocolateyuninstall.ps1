$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scylla'
$category = 'PE'

VM-Uninstall $toolName $category
