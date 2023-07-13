$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Tor Browser'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
