$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Regshot-x64-Unicode'
$category = 'Utilities'

VM-Uninstall $toolName $category
