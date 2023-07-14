$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Whisker'
$category = 'Exploitation'

VM-Uninstall $toolName $category
