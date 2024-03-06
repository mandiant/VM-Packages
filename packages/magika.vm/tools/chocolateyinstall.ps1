$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'magika'
    $category = 'File Information'
    $executablePath = "$toolName"
    $arguments = "-h"
    $iconLocation = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve

    VM-Pip-Install $toolName

    VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -arguments $arguments -iconLocation $iconLocation
} catch {
    VM-Write-Log-Exception $_
}
