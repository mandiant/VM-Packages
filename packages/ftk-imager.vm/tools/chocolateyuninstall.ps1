$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FTK Imager'
$category = 'Forensic'

VM-Uninstall $toolName $category
