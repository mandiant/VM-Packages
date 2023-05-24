$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MiniDump'
$category = 'Credential Access'

VM-Uninstall $toolName $category
