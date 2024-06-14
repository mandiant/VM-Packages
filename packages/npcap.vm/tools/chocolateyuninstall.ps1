$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

VM-Uninstall-With-Uninstaller "Npcap*" "" "EXE" "/S"

