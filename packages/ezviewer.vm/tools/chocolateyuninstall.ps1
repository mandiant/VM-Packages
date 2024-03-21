$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EZViewer'
$category = 'Documents'

VM-Uninstall $toolName $category
