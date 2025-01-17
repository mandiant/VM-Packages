$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uncompyle6'
$category = 'Python'

VM-Uninstall-With-Pip $toolName $category
