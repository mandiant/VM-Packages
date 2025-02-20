$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'file'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
