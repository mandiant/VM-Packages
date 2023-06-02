$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Whisker'
$category = 'Active Directory'

VM-Uninstall $toolName $category
