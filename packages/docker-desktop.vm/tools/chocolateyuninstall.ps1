$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'docker-desktop'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
