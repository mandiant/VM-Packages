$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Outflank C2 Tool Collection'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
