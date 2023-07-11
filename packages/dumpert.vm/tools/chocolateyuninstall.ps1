$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dumpert'
$category = 'Credential Access'

VM-Uninstall $toolName $category
