$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Unhook BOF'
$category = 'Command & Control'

VM-Uninstall $toolName $category
