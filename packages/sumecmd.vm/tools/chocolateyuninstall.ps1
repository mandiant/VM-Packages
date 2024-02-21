$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SumECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
