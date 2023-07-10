$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerZure'
$category = 'Exploitation'

VM-Uninstall $toolName $category
