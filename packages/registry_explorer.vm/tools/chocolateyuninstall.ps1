$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegistryExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
