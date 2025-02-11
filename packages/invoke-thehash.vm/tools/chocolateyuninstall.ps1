$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-TheHash'
$category = 'Lateral Movement'

VM-Uninstall $toolName $category