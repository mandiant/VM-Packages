$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AppCompatCacheParser'
$category = 'Forensic'

VM-Uninstall $toolName $category
