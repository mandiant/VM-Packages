$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Remote Operations BOF'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
