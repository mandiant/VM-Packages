$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $pluginsDir = VM-Get-IDA-Plugins-Dir

    # Remove plugin entrypoint and supporting module
    Remove-Item (Join-Path $pluginsDir "ida_cyberchef.py") -Force -ea 0 | Out-Null
    Remove-Item (Join-Path $pluginsDir "ida_cyberchef") -Recurse -Force -ea 0 | Out-Null
} catch {
    VM-Write-Log-Exception $_
}
