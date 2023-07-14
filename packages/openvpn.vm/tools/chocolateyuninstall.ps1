$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'OpenVPN'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
