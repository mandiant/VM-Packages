$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'shellcode_launcher'
$category = 'Utilities'

VM-Uninstall $toolName $category
