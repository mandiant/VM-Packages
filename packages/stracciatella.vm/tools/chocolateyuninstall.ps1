$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Stracciatella'
$category = 'Command & Control'

VM-Uninstall $toolName $category
