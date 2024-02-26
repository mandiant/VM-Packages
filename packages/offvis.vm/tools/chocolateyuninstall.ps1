$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'OffVis'
$category = 'Documents'

VM-Uninstall $toolName $category
