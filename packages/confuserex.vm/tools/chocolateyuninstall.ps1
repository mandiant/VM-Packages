$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ConfuserEx'
$category = 'Evasion'

VM-Remove-Tool-Shortcut $toolName $category
