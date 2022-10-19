$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RunDotNetDll'
$category = 'dotNet'

VM-Uninstall $toolName $category
