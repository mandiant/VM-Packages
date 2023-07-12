$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'innoextract'
$category = 'InnoSetup'

VM-Uninstall $toolName $category
