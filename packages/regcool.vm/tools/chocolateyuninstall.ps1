$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = 'Registry'

VM-Uninstall $toolName $category
