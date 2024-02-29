$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = 'Utilities'

VM-Uninstall $toolName $category
