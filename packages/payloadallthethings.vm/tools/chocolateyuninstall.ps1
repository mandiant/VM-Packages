$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PayloadAllTheThings'
$category = 'Wordlists'

VM-Uninstall $toolName $category
