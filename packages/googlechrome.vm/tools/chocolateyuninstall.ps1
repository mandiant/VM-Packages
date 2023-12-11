$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Chrome'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
