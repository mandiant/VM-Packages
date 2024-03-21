$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SBECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
