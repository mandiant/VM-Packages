$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

VM-Uninstall $toolName $category
