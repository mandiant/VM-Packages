$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SysWhispers3'
$category = 'Payload Development'

VM-Uninstall $toolName $category
