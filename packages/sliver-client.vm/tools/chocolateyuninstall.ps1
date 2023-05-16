$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Sliver-Client'
$category = 'Command & Control'

VM-Uninstall $toolName $category
