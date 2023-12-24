$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FuzzDB'
$category = 'Wordlists'

VM-Uninstall $toolName $category
