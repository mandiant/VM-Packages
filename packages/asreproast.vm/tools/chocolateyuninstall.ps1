$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ASREPRoast'
$Category = 'Credential Access'

VM-Uninstall $toolName $category