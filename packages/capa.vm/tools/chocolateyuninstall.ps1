$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

VM-Uninstall $toolName $category
