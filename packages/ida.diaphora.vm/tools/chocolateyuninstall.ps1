$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$category = 'Utilities'

VM-Uninstall $toolName $category
