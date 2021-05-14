$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hashmyfiles'
$category = 'Utilities'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName "file"
VM-Remove-From-Right-Click-Menu $toolName "directory"