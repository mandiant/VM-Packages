$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'npcap'
$category = 'Networking'

VM-Uninstall $toolName $category
