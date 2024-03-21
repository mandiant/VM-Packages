$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner64'
$category = 'Shellcode'

VM-Uninstall $toolName $category
