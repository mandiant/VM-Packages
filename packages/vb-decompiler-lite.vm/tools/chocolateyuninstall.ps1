$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Uninstaller $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

VM-Uninstall $toolName $category
