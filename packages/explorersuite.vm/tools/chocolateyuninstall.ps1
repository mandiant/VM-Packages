$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$category = 'PE'
$subtoolNames = 'CFF Explorer', 'PE Detective', 'Task Explorer', 'Task Explorer-x64'
foreach ($subtoolName in $subtoolNames) {
  VM-Remove-Tool-Shortcut  $subtoolName $category
}

VM-Remove-From-Right-Click-Menu 'Open with CFF Explorer'

VM-Uninstall-With-Uninstaller "Explorer Suite IV" $category "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
