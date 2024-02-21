$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
