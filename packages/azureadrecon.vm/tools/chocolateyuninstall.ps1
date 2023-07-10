$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureADRecon'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
