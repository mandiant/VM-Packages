$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ProcessHacker'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
