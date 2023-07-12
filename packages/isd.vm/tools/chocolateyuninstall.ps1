$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Inno Setup Decompiler'
$category = 'Utilities'

VM-Uninstall $toolName $category
