$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'HxD'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
Uninstall-BinFile -Name $toolName
