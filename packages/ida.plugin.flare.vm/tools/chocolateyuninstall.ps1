$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$pluginItems = @('apply_callee_type_plugin.py',
                 'shellcode_hashes_search_plugin.py',
                 'flare')

ForEach ($name in $pluginItems) {
    VM-Uninstall-IDA-Plugin -pluginName $name
}

Remove-Item "$Env:APPDATA\Hex-Rays\IDA Pro\shellcode_hashes" -Force -Recurse
