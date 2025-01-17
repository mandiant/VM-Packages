$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ida'
$category = 'Disassemblers'

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Silently uninstall
VM-Uninstall-With-Uninstaller "IDA Freeware*" $category "EXE" "--mode unattended" | Out-Null
