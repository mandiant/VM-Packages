$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RpcView'
$category = 'Utilities'

VM-Uninstall $toolName $category
