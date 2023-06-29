$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpWMI'
$category = 'Information Gathering'

VM-Uninstall $toolName $category
