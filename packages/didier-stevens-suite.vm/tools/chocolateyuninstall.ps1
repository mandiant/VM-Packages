$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

# Remove shortcuts
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
ForEach ($toolName in @('pdfid', 'pdf-parser')) {
  VM-Remove-Tool-Shortcut $toolName $category
}

# Remove tool directory
$toolDir = Get-Item "${Env:RAW_TOOLS_DIR}\DidierStevensSuite-*"
Remove-Item $toolDir -Recurse -Force -ea 0
