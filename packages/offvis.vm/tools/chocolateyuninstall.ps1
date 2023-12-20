$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'OffVis'
$category = 'Office'

VM-Uninstall $toolName $category
