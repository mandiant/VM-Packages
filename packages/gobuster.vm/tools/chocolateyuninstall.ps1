$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
