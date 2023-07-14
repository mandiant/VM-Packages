$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Resource Hacker'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
