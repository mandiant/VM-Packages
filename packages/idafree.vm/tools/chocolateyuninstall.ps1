$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'idafree'
$category = 'Disassemblers'

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "IDA Freeware*?7.6" "EXE" "--mode unattended"