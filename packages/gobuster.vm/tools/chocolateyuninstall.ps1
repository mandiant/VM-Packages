$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
