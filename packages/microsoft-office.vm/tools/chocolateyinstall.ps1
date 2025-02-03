$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install with choco instead as dependency to provide params such the product
    choco install microsoft-office-deployment --params="'/DisableUpdate:TRUE  /Product:ProPlus2024Retail'" --no-progress
} catch {
    VM-Write-Log-Exception $_
}
