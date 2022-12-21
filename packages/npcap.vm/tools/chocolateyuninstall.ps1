$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'npcap'
VM-Uninstall-With-Uninstaller $toolName "EXE" "/S"

