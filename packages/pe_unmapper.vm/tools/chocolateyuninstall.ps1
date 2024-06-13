$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pe_unmapper'
$category = 'PE'

VM-Uninstall $toolName $category
