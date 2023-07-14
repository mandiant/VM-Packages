$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotNetToJScript'
$category = 'Payload Development'

VM-Uninstall $toolName $category
