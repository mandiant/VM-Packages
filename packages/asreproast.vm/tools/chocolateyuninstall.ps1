$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ASREPRoast'
$category = 'Password Attacks'

VM-Uninstall $toolName $category