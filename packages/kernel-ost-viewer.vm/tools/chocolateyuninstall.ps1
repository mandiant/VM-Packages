$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kernel OST Viewer'
$category = 'Forensic'

VM-Uninstall $toolName $category
