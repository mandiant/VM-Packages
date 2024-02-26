$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'File Information'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v3.0.1/floss-v3.0.1-windows.zip"
$zipSha256 = "eeed5d8eec831fbc7ca7e2fc2c6a3c548993682a49477ae63335bbdff9d52ae5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
