$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpSecDump'
$category = 'Credential Access'

VM-Uninstall $toolName $category
