$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'd2j-dex2jar'
$category = 'Java/Android'

VM-Uninstall $toolName $category
