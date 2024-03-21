$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerCat'
$category = 'Networking'

VM-Uninstall $toolName $category
