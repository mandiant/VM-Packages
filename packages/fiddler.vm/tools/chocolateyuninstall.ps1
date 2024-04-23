$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'fiddler'
$category = 'Networking'

VM-Remove-Tool-Shortcut $toolName $category
Uninstall-BinFile -Name $toolName

