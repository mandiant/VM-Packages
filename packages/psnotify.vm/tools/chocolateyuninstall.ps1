$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'psnotify'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$toolDir = 'C:\psnotify'

# Remove tool files
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category