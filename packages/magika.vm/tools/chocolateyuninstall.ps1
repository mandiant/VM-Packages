$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = 'File Information'

VM-Uninstall-With-Pip -toolName $toolName -category $category
