$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Utilities'

VM-Uninstall $toolName $category
