$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SrumECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
