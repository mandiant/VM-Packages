$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Packers'

VM-Uninstall $toolName $category
