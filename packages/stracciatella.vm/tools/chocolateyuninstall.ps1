$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Stracciatella'
$category = 'Payload Development'

VM-Uninstall $toolName $category
