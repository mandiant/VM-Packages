$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BurpSuiteCommunity'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
