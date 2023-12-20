$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '7z'

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "7-Zip 15.05*" "EXE" "/S"

$extensions = @(".7z", ".bzip2", ".gzip", ".tar", ".wim", ".xz", ".txz", ".zip", ".rar")
foreach ($extension in $extensions) {
  VM-Remove-From-Right-Click-Menu $toolName -extension $extension
}
