$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JLECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
