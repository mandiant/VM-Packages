$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'wireshark'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
