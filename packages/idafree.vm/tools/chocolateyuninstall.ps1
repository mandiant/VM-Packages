$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'idafree'

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "IDA Freeware*?8.3" "EXE" "--mode unattended"
