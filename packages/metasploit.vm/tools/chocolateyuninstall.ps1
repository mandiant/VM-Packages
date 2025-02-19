$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Metasploit'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category

# Silently uninstall
VM-Uninstall-With-Uninstaller $toolName $category "MSI" "/q /norestart"

# Remove directory, shortcut, shim
VM-Uninstall $toolName $category