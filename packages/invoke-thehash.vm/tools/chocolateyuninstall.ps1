$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-TheHash'
$category = 'Exploitation'

VM-Uninstall $toolName $category