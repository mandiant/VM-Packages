$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$category = 'Utilities'
$subtoolNames = 'CFF Explorer', 'PE Detective', 'Task Explorer', 'Task Explorer-x64'
foreach ($subtoolName in $subtoolNames) {
  VM-Remove-Tool-Shortcut  $subtoolName $category
}

VM-Uninstall-With-Uninstaller "Explorer Suite IV" "EXE" "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"