$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Covenant'
$category = 'Command & Control'

VM-Uninstall $toolName $category
