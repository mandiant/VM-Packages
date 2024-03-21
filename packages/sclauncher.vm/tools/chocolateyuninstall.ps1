$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = 'Shellcode'

VM-Uninstall $toolName $category
