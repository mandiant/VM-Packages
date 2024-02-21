$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
