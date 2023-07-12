$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'syswhispers'
$category = 'Evasion'

VM-Uninstall $toolName $category
