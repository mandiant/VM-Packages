$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'sysinternals'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName $category
# Remove tools shortcuts
$shortcuts = @{
'Utilities' = @('procexp', 'procmon')
'Reconnaissance' = @('ADExplorer')
}
ForEach ($category in $shortcuts.GetEnumerator()) {
    ForEach ($toolName in $category.value) {
        VM-Remove-Tool-Shortcut $toolName $category.key
    }
}

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null

# Refresh Desktop as the shortcuts are used in FLARE-VM LayoutModification.xml
VM-Refresh-Desktop
