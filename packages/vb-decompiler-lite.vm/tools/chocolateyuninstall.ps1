$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VB Decompiler Lite'
$category = 'Visual Basic'

VM-Uninstall-With-Uninstaller $toolName $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

VM-Uninstall $toolName $category
