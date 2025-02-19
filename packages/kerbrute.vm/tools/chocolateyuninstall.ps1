$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kerbrute'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
