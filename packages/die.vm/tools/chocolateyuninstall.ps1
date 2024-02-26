$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'die'
$category = 'File Information'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
