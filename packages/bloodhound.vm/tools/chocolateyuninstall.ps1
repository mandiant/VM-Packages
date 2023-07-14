$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category

