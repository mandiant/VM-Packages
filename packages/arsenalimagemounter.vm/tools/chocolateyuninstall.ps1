$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ArsenalImageMounter'
$category = 'Forensic'

VM-Remove-Tool-Shortcut $toolName $category
