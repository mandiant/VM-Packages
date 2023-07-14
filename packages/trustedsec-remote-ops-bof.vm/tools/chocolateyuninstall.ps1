$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Remote Operations BOF'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
