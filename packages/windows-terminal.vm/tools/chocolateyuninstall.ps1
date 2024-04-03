$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Windows Terminal'
$category = 'Productivity Tools'

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu -menuKey $toolName -type "directory" -background
