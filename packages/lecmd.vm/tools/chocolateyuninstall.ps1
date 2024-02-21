$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
