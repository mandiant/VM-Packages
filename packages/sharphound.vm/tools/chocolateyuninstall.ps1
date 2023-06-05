$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
