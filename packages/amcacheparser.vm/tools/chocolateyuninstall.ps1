$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AmcacheParser'
$category = 'Forensic'

VM-Uninstall $toolName $category
