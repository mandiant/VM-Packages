$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v2.2.0/floss-v2.2.0-windows.zip"
$zipSha256 = "edc206110a62bba4c27ff245d93e66d237c74c27f98ae05b9478151fbaed8aee"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

