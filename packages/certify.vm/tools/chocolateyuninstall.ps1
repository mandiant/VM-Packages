$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Certify'
$category = 'Exploitation'

VM-Uninstall $toolName $category
