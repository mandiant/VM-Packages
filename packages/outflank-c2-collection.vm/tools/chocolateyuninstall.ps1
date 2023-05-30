$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Outflank C2 Tool Collection'
$category = 'Command & Control'

VM-Uninstall $toolName $category
