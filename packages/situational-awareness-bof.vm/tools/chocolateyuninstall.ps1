$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
