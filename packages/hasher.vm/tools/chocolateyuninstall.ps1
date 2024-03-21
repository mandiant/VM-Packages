$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = 'File Information'

VM-Uninstall $toolName $category
