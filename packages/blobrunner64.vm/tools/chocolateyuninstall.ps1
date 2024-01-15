$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner64'
$category = 'Utilities'

VM-Uninstall $toolName $category
