$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TeamFiltration'
$category = 'Cloud'

VM-Uninstall $toolName $category
