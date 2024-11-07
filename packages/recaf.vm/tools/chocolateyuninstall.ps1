$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'recaf-2.21.14-J8-jar-with-dependencies'
$category = 'Java & Android'

VM-Uninstall $toolName $category
