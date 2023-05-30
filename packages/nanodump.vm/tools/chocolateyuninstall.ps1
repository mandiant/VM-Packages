$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NanoDump'
$category = 'Command & Control'

VM-Uninstall $toolName $category
