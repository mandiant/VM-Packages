$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'telnet'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
