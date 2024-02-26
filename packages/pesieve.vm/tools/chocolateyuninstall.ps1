$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pe-sieve'
$category = 'Memory'

VM-Remove-Tool-Shortcut $toolName $category
