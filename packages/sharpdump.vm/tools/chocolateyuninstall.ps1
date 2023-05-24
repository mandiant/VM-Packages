$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDump'
$category = 'Credential Access'

VM-Uninstall $toolName $category
