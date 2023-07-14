$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'heidisql'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
