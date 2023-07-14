$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Unhook BOF'
$category = 'Payload Development'

VM-Uninstall $toolName $category
