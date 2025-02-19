$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DB Browser for SQLite'
$subToolName = 'DB Browser for SQLCipher'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
VM-Remove-Tool-Shortcut $subToolName $category