$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

VM-Uninstall $toolName $category
