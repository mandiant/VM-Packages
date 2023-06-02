$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
