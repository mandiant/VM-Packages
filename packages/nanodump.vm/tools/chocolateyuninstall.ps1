$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NanoDump'
$Category = 'Credential Access'

VM-Uninstall $toolName $category
