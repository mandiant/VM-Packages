$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Tor Browser'
$category = 'Productivity Tools'

VM-Remove-Tool-Shortcut $toolName $category
