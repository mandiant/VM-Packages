$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Watson'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
