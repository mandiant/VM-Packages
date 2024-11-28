$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa Explorer Web'
$category = 'Utilities'

VM-Uninstall $toolName $category
