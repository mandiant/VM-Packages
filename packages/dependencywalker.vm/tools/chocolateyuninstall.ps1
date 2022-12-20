$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dependency Walker'
$category = 'PE'

VM-Remove-Tool-Shortcut $toolName $category

