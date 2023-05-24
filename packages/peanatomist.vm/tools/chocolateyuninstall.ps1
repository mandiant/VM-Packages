$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PEAnatomist'
$category = 'PE'

VM-Uninstall $toolName $category
