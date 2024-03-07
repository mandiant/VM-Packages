$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinDump'
$category = 'Networking'

VM-Uninstall $toolName $category
