$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ifpsdasm'
$category = 'InnoSetup'

VM-Uninstall $toolName $category
