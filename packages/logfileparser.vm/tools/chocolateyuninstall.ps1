$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LogFileParser64'
$category = 'Forensic'

VM-Uninstall $toolName $category
