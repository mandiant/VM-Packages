$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v1.7.0/floss-v1.7.0-windows.zip"
$zipSha256 = "9b433a949b210bb8a856de2546cb075c349e0c2582ee9bf6b5fe51d9f95e7690"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

