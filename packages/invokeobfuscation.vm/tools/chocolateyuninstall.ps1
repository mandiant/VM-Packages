$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-Obfuscation'
$category = 'Payload Development'

VM-Uninstall $toolName $category
