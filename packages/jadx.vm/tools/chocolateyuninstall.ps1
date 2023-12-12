$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'jadx'
$category = 'Forensic'

VM-Uninstall $toolName $category
