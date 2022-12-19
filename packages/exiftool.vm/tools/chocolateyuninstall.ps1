$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'exiftool'
$category = 'Utilities'

VM-Remove-Tool-Shortcut $toolName $category

