$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RLA'
$category = 'Forensic'

VM-Uninstall $toolName $category
