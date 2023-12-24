$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'dll_to_exe'
$category = 'PE'

VM-Uninstall $toolName $category
