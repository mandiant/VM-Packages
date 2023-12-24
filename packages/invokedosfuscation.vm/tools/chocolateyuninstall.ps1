$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-DOSfuscation'
$category = 'Payload Development'

VM-Uninstall $toolName $category
