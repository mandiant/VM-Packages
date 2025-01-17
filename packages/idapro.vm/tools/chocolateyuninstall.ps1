$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ida'
$category = 'Disassemblers'

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

# Replace tool shortcut's target by ida_launcher.exe
$launcherPath = Join-Path ${Env:RAW_TOOLS_DIR} "ida_launcher.exe"
$icon = Resolve-Path "${Env:ProgramFiles}\IDA*\$toolName.ico" | Select-Object -first 1
VM-Install-Shortcut -toolName $toolName -category $category -executablePath $launcherPath -IconLocation $icon

# Silently uninstall
VM-Uninstall-With-Uninstaller "IDA Pro*" $category "EXE" "--mode unattended" | Out-Null
