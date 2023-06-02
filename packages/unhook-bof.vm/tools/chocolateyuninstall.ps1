$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Unhook BOF'
$category = 'Evasion'

VM-Uninstall $toolName $category
