$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BinaryNinja Free'
$category = 'Disassemblers'
VM-Remove-Tool-Shortcut $toolName $category

Uninstall-BinFile -Name $toolName

VM-Uninstall-With-Uninstaller "Binary Ninja*" $category "EXE" "/S /ALLUSERS=1"