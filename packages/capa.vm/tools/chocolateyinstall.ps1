$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v7.0.1/capa-v7.0.1-windows.zip"
$zipSha256 = "05bac209f50302308e37eb658fe36a40418aa9c37f57d440355706e13cabc43d"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
