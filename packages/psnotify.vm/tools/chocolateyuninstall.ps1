$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'psnotify'
$category = 'dotNet'
$toolDir = 'C:\psnotify'

# Remove tool files
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category