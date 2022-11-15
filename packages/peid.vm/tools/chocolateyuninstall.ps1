$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'peid'
$category = 'PE'

VM-Uninstall $toolName $category
