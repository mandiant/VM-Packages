$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = 'Utilities'

VM-Uninstall $toolName $category
