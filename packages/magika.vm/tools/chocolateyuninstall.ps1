$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = 'File Information'

Invoke-Expression "py -3.10 -m pip uninstall $toolName -y"

VM-Uninstall $toolName $category
