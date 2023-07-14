$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Outflank C2 Tool Collection'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
