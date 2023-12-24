$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerMad'
$category = 'Exploitation'

VM-Uninstall $toolName $category
