$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Thunderbird'
$category = 'Email'

VM-Remove-Tool-Shortcut $toolName $category
