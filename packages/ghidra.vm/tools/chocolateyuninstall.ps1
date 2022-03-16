$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ghidra'
$category = 'Disassemblers'

VM-Remove-Tool-Shortcut $toolName $category
