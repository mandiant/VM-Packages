$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
