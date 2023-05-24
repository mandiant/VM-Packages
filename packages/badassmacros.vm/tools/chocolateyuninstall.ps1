$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BadAssMacros'
$category = 'Payload Development'

VM-Uninstall $toolName $category
