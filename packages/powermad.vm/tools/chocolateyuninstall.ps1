$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerMad'
$category = 'Android'

VM-Uninstall $toolName $category
