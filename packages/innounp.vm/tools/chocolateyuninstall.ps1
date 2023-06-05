$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'innounp'
$category = 'Utilities'

VM-Uninstall $toolName $category
