$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpExec'
$category = 'Lateral Movement'

VM-Uninstall $toolName $category
