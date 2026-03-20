$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pylingual'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Pip-Uninstall $toolName
VM-Remove-Tool-Shortcut $toolName $category
