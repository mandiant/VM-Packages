$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'yara'
$category = 'Forensic'

VM-Uninstall $toolName $category
