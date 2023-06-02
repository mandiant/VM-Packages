$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GadgetToJScript'
$category = 'Evasion'

VM-Uninstall $toolName $category
