$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'File Information'

VM-Uninstall $toolName $category
