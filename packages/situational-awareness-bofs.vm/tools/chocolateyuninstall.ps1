$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$category = 'Command & Control'

VM-Uninstall $toolName $category
