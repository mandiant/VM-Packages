$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'nmap'
    $category = 'Networking'
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Remove shortcuts for all the EXE's
    $exePaths = Get-ChildItem $toolDir | Where-Object { $_.Name -match '^.*(?<!Uninstall|zenmap)\.exe$' }
    foreach ($exe in $exePaths) {
        VM-Remove-Tool-Shortcut $exe.Basename $category
        Uninstall-BinFile -Name $exe.Basename
    }

    # Remove shortcut for Zenmap
    VM-Remove-Tool-Shortcut "zenmap" $category
    Uninstall-BinFile -Name "zenmap"

    # Silently uninstall
    VM-Uninstall-With-Uninstaller "Nmap*" "EXE" "/S"
} catch {
    VM-Write-Log-Exception $_
}

