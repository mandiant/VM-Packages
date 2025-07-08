$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scdbg'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category

# Remove GUI variant of scdbg
VM-Remove-Tool-Shortcut 'scdbg_gui' $category
Uninstall-BinFile -Name 'scdbg_gui'

