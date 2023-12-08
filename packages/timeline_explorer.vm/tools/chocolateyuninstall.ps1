$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TimelineExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
