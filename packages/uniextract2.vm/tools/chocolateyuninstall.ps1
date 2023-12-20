$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'UniExtract'
$category = 'Packers'

VM-Uninstall $toolName $category
