$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SDBExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
