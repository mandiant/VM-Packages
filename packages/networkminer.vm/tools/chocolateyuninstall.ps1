$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = 'Networking'

VM-Uninstall $toolName $category
