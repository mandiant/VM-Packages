$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pyghidra'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Pip $toolName $category
