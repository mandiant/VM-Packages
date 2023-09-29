$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'd2j-dex2jar'
$category = 'Java'

VM-Uninstall $toolName $category
