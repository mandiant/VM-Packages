$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegistryExplorer'
$category = 'Registry'

VM-Uninstall $toolName $category
