$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Cloud'

VM-Uninstall $toolName $category
