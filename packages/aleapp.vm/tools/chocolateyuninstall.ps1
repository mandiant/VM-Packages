$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'aleappGUI'
$category = 'Forensic'

VM-Uninstall $toolName $category
