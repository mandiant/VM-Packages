$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RecentFileCacheParser'
$category = 'Forensic'

VM-Uninstall $toolName $category
