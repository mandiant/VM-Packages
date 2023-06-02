$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpUp'
$category = 'Exploitation'

VM-Uninstall $toolName $category
