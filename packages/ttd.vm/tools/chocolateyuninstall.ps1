$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = "ttd"
$category = "Debuggers"

VM-Remove-Tool-Shortcut $toolName $category

Get-AppxPackage *TimeTravelDebugging* | Remove-AppPackage
