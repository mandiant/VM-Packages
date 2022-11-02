$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v2.1.0/floss-v2.1.0-windows.zip"
$zipSha256 = "925df10403b45e29914e44ac50d92d762b2b2499c11cdd1801888aac95b53eb7"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

