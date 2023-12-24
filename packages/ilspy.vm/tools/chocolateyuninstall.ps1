$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ILSpy'
$category = 'dotNet'

VM-Remove-Tool-Shortcut $toolName $category
