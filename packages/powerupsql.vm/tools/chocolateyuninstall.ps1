$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerUpSQL'
$category = 'Exploitation'

VM-Uninstall $toolName $category
