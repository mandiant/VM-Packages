$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$Category = 'Reconnaissance'

VM-Uninstall $toolName $category
