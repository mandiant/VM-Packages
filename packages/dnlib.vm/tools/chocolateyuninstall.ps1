$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'dnlib'
$category = 'dotNet'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

# Remove tool files
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category
