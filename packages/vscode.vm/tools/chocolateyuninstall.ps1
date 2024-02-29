$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCode'
$category = 'Productivity Tools'

VM-Remove-Tool-Shortcut $toolName $category
