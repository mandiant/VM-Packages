$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scdbg'
$category = 'Debuggers'

VM-Uninstall $toolName $category
