$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ShellBagsExplorer'
$category = 'Forensic'

VM-Uninstall $toolName $category
