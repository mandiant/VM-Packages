$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'diaphora'
    $category = 'Utilities'
    $executableName = "diaphora.py"

    $zipUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/2.1.0.zip'
    $zipSha256 = 'bd946942081b46991e8ee5a2788088110e0eef7649791c661ed41566d4dd2993'

    # Diaphora needs to be executed from IDA, do not install bin file
    VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -innerFolder $true -withoutBinFile
} catch {
    VM-Write-Log-Exception $_
}
