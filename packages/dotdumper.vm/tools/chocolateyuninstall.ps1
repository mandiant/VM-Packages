$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotDumper'
$category = 'dotNet'

VM-Uninstall $toolName $category
