$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v9.0.0/capa-v9.0.0-windows.zip"
$zipSha256 = "139d20b415063152adfb6b8c566bf2bc0a37f2150c6420e6209704b6be20be20"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
