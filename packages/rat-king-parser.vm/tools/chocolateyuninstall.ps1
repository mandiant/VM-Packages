$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'rat-king-parser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Pip $toolName $category
