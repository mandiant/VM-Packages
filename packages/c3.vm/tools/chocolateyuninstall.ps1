$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'C3'
$category = 'Command & Control'

VM-Uninstall $toolName $category
