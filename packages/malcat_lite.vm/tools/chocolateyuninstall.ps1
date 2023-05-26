$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'malcat'
$category = 'Hex Editors'

VM-Uninstall $toolName $category
