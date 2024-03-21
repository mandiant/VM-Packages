$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'exeinfope'
$category = 'File Information'

VM-Uninstall $toolName $category
