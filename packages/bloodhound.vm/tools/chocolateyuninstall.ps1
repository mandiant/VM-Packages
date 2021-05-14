$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound'
$category = 'Information Gathering'

VM-Uninstall $toolName $category

