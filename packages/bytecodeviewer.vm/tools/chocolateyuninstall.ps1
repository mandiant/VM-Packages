$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bytecode Viewer'
$category = 'Java'

VM-Uninstall $toolName $category
