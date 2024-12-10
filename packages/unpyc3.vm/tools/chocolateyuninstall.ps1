$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'unpyc3'
$category = 'Python'

VM-Remove-Tool-Shortcut $toolName $category
