$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName32 = 'apimonitor-x86'
$toolName64 = 'apimonitor-x64'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName32 $category
VM-Remove-Tool-Shortcut $toolName64 $category
