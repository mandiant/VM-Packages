$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WSL'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
