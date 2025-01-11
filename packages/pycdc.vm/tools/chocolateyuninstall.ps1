$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pycdc'
$category = 'Python'

VM-Uninstall $toolName $category
