$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoBuster'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
