$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Net-GPPPassword'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
