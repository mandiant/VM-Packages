$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpView'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
