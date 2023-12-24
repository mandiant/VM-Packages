$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SafetyKatz'
$category = 'Credential Access'

VM-Uninstall $toolName $category
