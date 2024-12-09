$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa-explorer-web'
$category = 'Utilities'

VM-Uninstall $toolName $category
