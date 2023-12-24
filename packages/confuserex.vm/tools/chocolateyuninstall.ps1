$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ConfuserEx'
$category = 'Payload Development'

VM-Remove-Tool-Shortcut $toolName $category
