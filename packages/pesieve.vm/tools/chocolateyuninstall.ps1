$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pe-sieve'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
