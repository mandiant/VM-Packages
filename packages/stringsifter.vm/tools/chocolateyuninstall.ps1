$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'stringsifter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

Invoke-Expression "py -3.11 -m pip uninstall $toolName -y --disable-pip-version-check 2>&1"
VM-Remove-Tool-Shortcut $toolName $category
