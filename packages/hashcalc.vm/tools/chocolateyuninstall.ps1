$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'HashCalc'
    $category = 'Utilities'

    # Remove shortcuts for HashCalc
    VM-Remove-Tool-Shortcut $toolName $category
    Uninstall-BinFile -Name $toolName

    # Silently Uninstall
    VM-Uninstall-With-Uninstaller "unins000.exe" "EXE" "/S"
    # Remove HashCalc Folder in C:\Tools and shortcut
    Remove-Item (Join-Path ${Env:RAW_TOOLS_DIR} $toolName) -Recurse
    Remove-Item (Join-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" $toolName) -Recurse

} catch {
    VM-Write-Log-Exception $_
}