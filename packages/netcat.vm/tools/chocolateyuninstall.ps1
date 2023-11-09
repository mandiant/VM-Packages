$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'nc'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
