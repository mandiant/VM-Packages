$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DCode'
$category = 'Utilities'

VM-Uninstall $toolName $category
