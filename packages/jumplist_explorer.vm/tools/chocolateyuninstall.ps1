$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JumpListExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
