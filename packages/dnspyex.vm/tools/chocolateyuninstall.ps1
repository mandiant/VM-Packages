$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'dnSpy'
$category = 'dotNet'

VM-Uninstall $toolName $category

$toolNameX86 = "$toolName-x86"
VM-Remove-Tool-Shortcut $toolNameX86 $category
Uninstall-BinFile -Name $toolNameX86

$toolNameConsole = "$toolName.Console"
VM-Remove-Tool-Shortcut $toolNameConsole $category
Uninstall-BinFile -Name $toolNameConsole
