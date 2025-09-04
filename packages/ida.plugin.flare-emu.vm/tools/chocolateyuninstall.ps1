$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$scriptNames = @('flare_emu.py',
                 'flare_emu_hooks.py',
                 'flare_emu_ida.py',
                 'rename_dynamic_imports.py')

ForEach ($scriptName in $scriptNames) {
    $scriptPath = Join-Path "$Env:APPDATA\Hex-Rays\IDA Pro\python" $scriptName
    Remove-Item $scriptPath -Recurse -Force -ea 0
}
