$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Remote Operations BOF'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
