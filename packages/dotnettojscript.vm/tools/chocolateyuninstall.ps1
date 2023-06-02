$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotNetToJScript'
$category = 'Evasion'

VM-Uninstall $toolName $category
