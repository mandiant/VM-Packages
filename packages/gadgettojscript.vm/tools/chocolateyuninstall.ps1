$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GadgetToJScript'
$category = 'Payload Development'

VM-Uninstall $toolName $category
