$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'Utilities'

VM-Uninstall $toolName $category
