$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDPAPI'
$category = 'Exploitation'

VM-Uninstall $toolName $category
