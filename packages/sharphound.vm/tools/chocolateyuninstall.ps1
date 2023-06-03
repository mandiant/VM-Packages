$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Exploitation'

VM-Uninstall $toolName $category
