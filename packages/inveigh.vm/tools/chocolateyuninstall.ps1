$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Inveigh'
$category = 'Credential Access'

VM-Uninstall $toolName $category
