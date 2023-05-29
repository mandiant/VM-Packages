$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ADConnectDump'
$category = 'Cloud'

VM-Uninstall $toolName $category
