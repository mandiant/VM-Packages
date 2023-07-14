$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TeamFiltration'
$category = 'Exploitation'

VM-Uninstall $toolName $category
