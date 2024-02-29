$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'shellcode_launcher'
$category = 'Shellcode'

VM-Uninstall $toolName $category
