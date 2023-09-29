$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pkg-unpacker'
$category = 'Packers'

VM-Uninstall $toolName $category
