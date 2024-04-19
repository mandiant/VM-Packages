$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'File Information'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v3.1.0/floss-v3.1.0-windows.zip"
$zipSha256 = "a2153c4fa542e995b1bb94b9d68e0aa39aa580999d33e84d6942b8296636bad5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
