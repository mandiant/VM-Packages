$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Azure PowerShell'
$category = 'Cloud'

VM-Remove-Tool-Shortcut $toolName $category
