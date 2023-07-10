$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFASweep'
$category = 'Credential Access'

VM-Uninstall $toolName $category
