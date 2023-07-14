$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Whisker'
$category = 'Persistence'

VM-Uninstall $toolName $category
