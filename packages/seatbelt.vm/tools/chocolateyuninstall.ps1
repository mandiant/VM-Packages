$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SeatBelt'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
