$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'magika'
    $category = 'File Information'

    VM-Pip-Install $toolName

    $executablePath = "$(where.exe $toolName)"
    $arguments = "--help"

    VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -arguments $arguments -iconLocation $iconLocation
} catch {
    VM-Write-Log-Exception $_
}
