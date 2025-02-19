$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'asar'
$category = 'PE'

VM-Uninstall $toolName $category
