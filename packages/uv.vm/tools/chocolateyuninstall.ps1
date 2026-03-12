$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uv'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
