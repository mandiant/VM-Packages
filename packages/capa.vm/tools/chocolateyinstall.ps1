$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v6.1.0/capa-v6.1.0-windows.zip"
$zipSha256 = "070923d5ca225ef29a670af9cc66a8d648fcaaff7e283cb1ddc73de6e3610f0f"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

