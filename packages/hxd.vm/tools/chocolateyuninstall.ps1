$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'HxD'
$category = 'Hex Editors'

VM-Remove-Tool-Shortcut $toolName $category
VM-Remove-From-Right-Click-Menu $toolName "file"
Uninstall-BinFile -Name $toolName
