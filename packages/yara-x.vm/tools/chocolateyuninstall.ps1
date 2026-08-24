$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara-x'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
