$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Chrome'
$category = 'Web Application'

VM-Remove-Tool-Shortcut $toolName $category
