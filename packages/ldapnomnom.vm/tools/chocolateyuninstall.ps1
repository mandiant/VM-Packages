$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LDAPNomNom'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
