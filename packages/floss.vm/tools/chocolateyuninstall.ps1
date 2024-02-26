$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'File Information'

VM-Uninstall $toolName $category
