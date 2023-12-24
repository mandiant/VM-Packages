$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Event Log Explorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
