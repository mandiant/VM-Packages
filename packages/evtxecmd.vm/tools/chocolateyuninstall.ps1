$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvtxECmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
