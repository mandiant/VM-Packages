$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'innounp'
$category = 'InnoSetup'

VM-Uninstall $toolName $category
