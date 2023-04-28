$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'HeidiSQL'
    $category = 'Utilities'

    # Remove shortcuts for HeidiSQL
    VM-Remove-Tool-Shortcut $toolName $category
    Uninstall-BinFile -Name $toolName

    # Silently Uninstall
    VM-Uninstall-With-Uninstaller "unins000.exe" "EXE" "/S"
} catch {
    VM-Write-Log-Exception $_
}