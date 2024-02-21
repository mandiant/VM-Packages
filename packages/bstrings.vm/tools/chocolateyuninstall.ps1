$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'bstrings'
$category = 'Utilities'

VM-Uninstall $toolName $category
