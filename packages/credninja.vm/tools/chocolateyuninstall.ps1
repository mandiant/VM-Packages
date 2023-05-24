$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CredNinja'
$category = 'Credential Access'

VM-Uninstall $toolName $category
