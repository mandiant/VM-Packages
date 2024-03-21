$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = 'Shellcode'

VM-Uninstall $toolName $category
