$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpWMI'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
