$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'cyberchef'
$category = 'Utilities'

VM-Uninstall $toolName $category