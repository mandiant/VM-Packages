$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CodeTrack'
$category = 'dotNet'

VM-Remove-Tool-Shortcut $toolName $category
