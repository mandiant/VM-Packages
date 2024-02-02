$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = 'Utilities'

VM-Uninstall $toolName $category
