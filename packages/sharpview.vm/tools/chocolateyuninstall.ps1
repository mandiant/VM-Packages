$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpView'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
