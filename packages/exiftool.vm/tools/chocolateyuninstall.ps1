$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'exiftool'
$category = 'File Information'

VM-Remove-Tool-Shortcut $toolName $category

