$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Inno Setup Decompiler'
$category = 'InnoSetup'

VM-Uninstall $toolName $category
