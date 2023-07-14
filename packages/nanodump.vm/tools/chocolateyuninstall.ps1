$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NanoDump'
$category = 'Credential Access'

VM-Uninstall $toolName $category
