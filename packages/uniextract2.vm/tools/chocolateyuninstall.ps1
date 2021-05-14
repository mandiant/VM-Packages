$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'UniExtract'
$category = 'Utilities'

VM-Uninstall $toolName $category
