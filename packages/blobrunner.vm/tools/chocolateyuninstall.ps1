$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner'
$category = 'Shellcode'

VM-Uninstall $toolName $category
