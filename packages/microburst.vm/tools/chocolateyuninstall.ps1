$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MicroBurst'
$category = 'Exploitation'

VM-Uninstall $toolName $category
