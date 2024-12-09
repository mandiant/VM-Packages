$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v8.0.0/capa-v8.0.0-windows.zip"
$zipSha256 = "c127cc065dcbb6ccb6b70615e1e7699c8516dc108c78290bf770fee5459a25a1"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
