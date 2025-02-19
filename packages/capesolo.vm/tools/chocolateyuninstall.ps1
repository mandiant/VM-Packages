$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CAPEsolo'
$category = 'Debuggers'

VM-Uninstall-With-Pip $toolName $category
