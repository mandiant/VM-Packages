$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Certify'
$category = 'Active Directory'

VM-Uninstall $toolName $category
