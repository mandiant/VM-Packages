$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hashmyfiles'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu $toolName
VM-Remove-From-Right-Click-Menu $toolName -type "directory"
