$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hashcat'
$category = 'Credential Access'

VM-Uninstall $toolName $category
