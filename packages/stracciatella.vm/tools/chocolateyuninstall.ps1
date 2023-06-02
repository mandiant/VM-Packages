$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Stracciatella'
$category = 'Evasion'

VM-Uninstall $toolName $category
