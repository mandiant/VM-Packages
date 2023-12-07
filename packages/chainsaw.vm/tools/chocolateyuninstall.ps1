$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = 'Forensic'

VM-Uninstall $toolName $category
