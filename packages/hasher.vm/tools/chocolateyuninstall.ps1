$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = 'Utilities'

VM-Uninstall $toolName $category
