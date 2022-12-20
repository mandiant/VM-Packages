$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'HxD'
$category = 'Hex Editors'

VM-Remove-Tool-Shortcut $toolName $category
Uninstall-BinFile -Name $toolName

