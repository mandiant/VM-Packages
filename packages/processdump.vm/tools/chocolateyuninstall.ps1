$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = "pd"
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut ($toolName + "32") $category
VM-Remove-Tool-Shortcut ($toolName + "64") $category

Uninstall-BinFile -Name ($toolName + "32")
Uninstall-BinFile -Name ($toolName + "64")

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "Process-Dump"
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null