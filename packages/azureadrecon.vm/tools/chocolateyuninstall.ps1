$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureADRecon'
$category = 'Cloud'

VM-Uninstall $toolName $category
