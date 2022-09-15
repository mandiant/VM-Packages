$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'dnSpyEx'
$category = 'dotNet'

VM-Remove-Tool-Shortcut $toolName $category
