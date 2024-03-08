$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'notepad++'
$category = 'Productivity Tools'

VM-Uninstall $toolName $category
