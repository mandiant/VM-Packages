$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = 'Utilities'

VM-Uninstall $toolName $category
