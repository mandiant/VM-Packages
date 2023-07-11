$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PayloadsAllTheThings'
$category = 'Wordlists'

VM-Uninstall $toolName $category
