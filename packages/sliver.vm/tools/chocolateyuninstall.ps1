$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver'
$category = 'Command & Control'

VM-Uninstall $toolName $category
