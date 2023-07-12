$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SysWhispers2'
$category = 'Payload Development'

VM-Uninstall $toolName $category
