$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'StreamDivert'
$category = 'Networking'

VM-Uninstall $toolName $category
