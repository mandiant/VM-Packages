$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'idr'
$category = 'Delphi'

VM-Uninstall $toolName $category
