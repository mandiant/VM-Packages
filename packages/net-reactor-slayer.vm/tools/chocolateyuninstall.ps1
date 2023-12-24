$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NETReactorSlayer'
$category = 'dotNet'

VM-Remove-Tool-Shortcut $toolName $category
