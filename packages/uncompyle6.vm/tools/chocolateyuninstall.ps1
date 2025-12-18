$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uncompyle6'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName $category
Invoke-Expression "py.exe -3.13 -m pip uninstall $toolName -y --disable-pip-version-check 2>&1"
