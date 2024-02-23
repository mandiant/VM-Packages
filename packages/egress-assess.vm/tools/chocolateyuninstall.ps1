$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Egress-Assess'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
