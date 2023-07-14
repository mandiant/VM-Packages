$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpWMI'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
