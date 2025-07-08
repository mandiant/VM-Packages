$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Windows Terminal'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu -menuKey $toolName -type "directory" -background
