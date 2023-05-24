$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DB Browser for SQLite'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category
