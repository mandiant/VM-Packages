$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category

