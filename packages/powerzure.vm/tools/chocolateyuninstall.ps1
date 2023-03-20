$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerZure'
$category = 'Cloud'

VM-Uninstall $toolName $category
