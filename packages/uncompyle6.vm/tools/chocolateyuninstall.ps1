$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uncompyle6'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Pip $toolName $category
