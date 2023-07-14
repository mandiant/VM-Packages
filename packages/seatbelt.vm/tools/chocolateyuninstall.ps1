$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SeatBelt'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
