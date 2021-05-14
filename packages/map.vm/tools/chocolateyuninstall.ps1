$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Malcode Analyst Pack'
$category = 'Utilities'

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "Malcode Analyst Pack *" "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"