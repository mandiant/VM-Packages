$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Metasploit'
$category = 'Command & Control'

VM-Uninstall $toolName $category

# Silently uninstall
VM-Uninstall-With-Uninstaller $toolName "MSI" "/q /norestart"

# Remove directory, shortcut, shim
VM-Uninstall $toolName $category