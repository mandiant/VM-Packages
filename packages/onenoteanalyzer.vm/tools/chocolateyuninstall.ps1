$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'OneNoteAnalyzer'
$category = 'Documents'

VM-Remove-Tool-Shortcut $toolName $category
VM-Uninstall $toolName $category
