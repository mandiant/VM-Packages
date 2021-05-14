$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '7zip'
$category = 'Utilities'

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "7-Zip 15.05*" "EXE" "/S"