$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
