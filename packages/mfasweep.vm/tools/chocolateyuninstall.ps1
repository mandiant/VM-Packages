$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFASweep'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
