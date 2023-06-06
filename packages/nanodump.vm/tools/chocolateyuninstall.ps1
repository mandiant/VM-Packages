$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NanoDump'
$category = 'Password Attacks'

VM-Uninstall $toolName $category
