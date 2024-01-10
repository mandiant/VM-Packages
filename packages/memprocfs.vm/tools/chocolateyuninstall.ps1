$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = 'Forensic'

VM-Uninstall $toolName $category
