$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Pip -toolName $toolName -category $category
