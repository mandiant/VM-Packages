$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound-Custom-Queries'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
