$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
