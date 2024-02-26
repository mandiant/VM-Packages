$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Regshot-x64-Unicode'
$category = 'Registry'

VM-Uninstall $toolName $category
