$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RBCmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
