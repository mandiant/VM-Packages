$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCMount'
$category = 'Forensic'

VM-Uninstall $toolName $category
