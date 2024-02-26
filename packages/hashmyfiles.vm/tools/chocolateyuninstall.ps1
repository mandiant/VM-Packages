$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hashmyfiles'
$category = 'File Information'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
VM-Remove-From-Right-Click-Menu $toolName -type "directory"
