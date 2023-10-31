$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Internal-Monologue'
$category = 'Credential Access'

VM-Uninstall $toolName $category
