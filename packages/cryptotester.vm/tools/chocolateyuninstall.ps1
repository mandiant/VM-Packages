$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CryptoTester'
$category = 'Utilities'

VM-Uninstall $toolName $category
