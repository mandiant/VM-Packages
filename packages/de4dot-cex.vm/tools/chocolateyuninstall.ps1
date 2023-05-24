$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'de4dot'
$category = 'dotNet'

VM-Uninstall $toolName $category
VM-Remove-Tool-Shortcut "$toolName-x64" $category
