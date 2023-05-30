$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Remote Operations BOF'
$category = 'Command & Control'

VM-Uninstall $toolName $category
