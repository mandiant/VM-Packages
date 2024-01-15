$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner'
$category = 'Utilities'

VM-Uninstall $toolName $category
