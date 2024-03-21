$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
