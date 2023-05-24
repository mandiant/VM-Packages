$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpLAPS'
$category = 'Credential Access'

VM-Uninstall $toolName $category
