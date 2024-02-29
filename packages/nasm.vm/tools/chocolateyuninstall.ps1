$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'nasm'
$category = 'Productivity Tools'

VM-Remove-Tool-Shortcut $toolName $category
Uninstall-BinFile -Name $toolName
