$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PuTTY'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
