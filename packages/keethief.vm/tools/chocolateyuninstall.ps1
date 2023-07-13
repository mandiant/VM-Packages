$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'KeeThief'
$category = 'Credential Access'

VM-Uninstall $toolName $category
