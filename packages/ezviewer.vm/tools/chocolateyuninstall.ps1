$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EZViewer'
$category = 'Office'

VM-Uninstall $toolName $category
