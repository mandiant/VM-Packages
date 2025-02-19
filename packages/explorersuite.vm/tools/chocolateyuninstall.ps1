$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$subtoolNames = 'CFF Explorer', 'PE Detective', 'Task Explorer', 'Task Explorer-x64'
foreach ($subtoolName in $subtoolNames) {
  VM-Remove-Tool-Shortcut  $subtoolName $category
}

VM-Remove-From-Right-Click-Menu 'Open with CFF Explorer'

VM-Uninstall-With-Uninstaller "Explorer Suite IV" $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

# Refresh Desktop as CFF Explorer shortcut is used in FLARE-VM LayoutModification.xml
VM-Refresh-Desktop
