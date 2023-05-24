$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinDbg'
$category = 'Debuggers'

VM-Remove-Tool-Shortcut $toolName $category

Get-AppxPackage *WinDbg* | Remove-AppxPackage
