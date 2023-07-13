$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerSploit'
$category = 'Active Directory'

VM-Uninstall $toolName $category
