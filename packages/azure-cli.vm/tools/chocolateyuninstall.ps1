$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Azure-CLI'
$category = 'Cloud'

VM-Remove-Tool-Shortcut $toolName $category
