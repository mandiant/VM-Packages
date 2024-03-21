$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Wireshark'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
