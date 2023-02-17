$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

VM-Uninstall $toolName $category
