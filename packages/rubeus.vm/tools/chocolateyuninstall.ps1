$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Credential Access'

VM-Uninstall $toolName $category
