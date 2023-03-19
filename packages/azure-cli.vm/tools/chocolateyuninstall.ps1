$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'az'
$category = 'Cloud'

VM-Remove-Tool-Shortcut $toolName $category
