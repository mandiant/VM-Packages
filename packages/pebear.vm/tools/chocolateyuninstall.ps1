$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PE-bear'
$category = 'PE'

VM-Remove-Tool-Shortcut $toolName $category
