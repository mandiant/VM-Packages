$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v6.0.0/capa-v6.0.0-windows.zip"
$zipSha256 = "ca9a5388de86e95289426007ef794f6f6977ba6720f7fe5bc35a8cdc8a16f452"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

