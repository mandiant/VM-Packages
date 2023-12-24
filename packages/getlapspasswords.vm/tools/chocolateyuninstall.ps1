$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Get-LAPSPasswords'
$category = 'Credential Access'

VM-Uninstall $toolName $category
