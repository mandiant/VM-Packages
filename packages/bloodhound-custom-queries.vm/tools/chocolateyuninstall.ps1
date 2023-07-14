$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound-Custom-Queries'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
