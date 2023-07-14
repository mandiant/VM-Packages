$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinSCP'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
