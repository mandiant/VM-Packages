$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SpoolSample'
$category = 'Exploitation'

VM-Uninstall $toolName $category
