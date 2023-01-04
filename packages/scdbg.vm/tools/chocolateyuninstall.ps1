$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scdbg'
$category = 'Debuggers'

VM-Uninstall $toolName $category

# Remove GUI variant of scdbg
VM-Remove-Tool-Shortcut 'scdbg_gui' $category
Uninstall-BinFile -Name 'scdbg_gui'

