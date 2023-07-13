$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerSploit'
$category = 'Exploitation'

VM-Uninstall $toolName $category
