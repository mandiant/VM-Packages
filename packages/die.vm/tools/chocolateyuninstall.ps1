$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'die'
$category = 'Utilities'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
