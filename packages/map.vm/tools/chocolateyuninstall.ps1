$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Malcode Analyst Pack'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

# Remove tool shortcut
VM-Remove-Tool-Shortcut $toolName $category

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "Malcode Analyst Pack *" "$category" "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"