$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kerbrute'
$category = 'Credential Access'

VM-Uninstall $toolName $category
