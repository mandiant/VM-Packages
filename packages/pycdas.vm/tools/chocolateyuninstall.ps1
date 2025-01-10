$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pycdas'
$category = 'Python'

VM-Uninstall $toolName $category
