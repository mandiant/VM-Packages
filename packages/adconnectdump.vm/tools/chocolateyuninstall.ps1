$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ADConnectDump'
$category = 'Credential Access'

VM-Uninstall $toolName $category
