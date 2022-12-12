$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'vbdec'
$category = 'VB'

VM-Uninstall $toolName $category
