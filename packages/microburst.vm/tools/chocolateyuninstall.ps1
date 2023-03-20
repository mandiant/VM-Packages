$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MicroBurst'
$category = 'Cloud'

VM-Uninstall $toolName $category
