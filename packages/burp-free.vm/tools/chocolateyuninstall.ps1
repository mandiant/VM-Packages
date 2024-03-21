$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BurpSuiteCommunity'
$category = 'Web Application'

VM-Remove-Tool-Shortcut $toolName $category
