$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SeatBelt'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
