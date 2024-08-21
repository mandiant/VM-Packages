$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install with choco instead as dependency to provide params such the product
    choco install microsoft-office-deployment --params="'/DisableUpdate:TRUE /Language:en-us /Product:ProPlusRetail'"
} catch {
    VM-Write-Log-Exception $_
}
