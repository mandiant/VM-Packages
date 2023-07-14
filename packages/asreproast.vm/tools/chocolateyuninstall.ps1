$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ASREPRoast'
$category = 'Credential Access'

VM-Uninstall $toolName $category