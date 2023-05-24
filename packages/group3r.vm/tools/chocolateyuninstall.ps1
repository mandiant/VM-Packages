$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Group3r'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
