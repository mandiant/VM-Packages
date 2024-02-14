$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bochs x86 PC emulator'
$category = 'Debuggers'

VM-Uninstall $toolName $category
