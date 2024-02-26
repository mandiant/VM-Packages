$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DCode'
$category = 'Forensic'

VM-Uninstall $toolName $category
