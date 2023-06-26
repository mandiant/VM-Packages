$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound-Custom-Queries'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
