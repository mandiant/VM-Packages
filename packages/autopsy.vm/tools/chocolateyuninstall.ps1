$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Autopsy'
$category = 'Forensic'

VM-Uninstall $toolName $category
