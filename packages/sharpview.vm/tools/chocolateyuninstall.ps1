$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpView'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
