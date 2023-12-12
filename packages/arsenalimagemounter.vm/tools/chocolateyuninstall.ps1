$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ArsenalImageMounter'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
