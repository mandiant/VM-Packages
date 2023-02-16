$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'file'
$category = 'Utilities'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName "file"
