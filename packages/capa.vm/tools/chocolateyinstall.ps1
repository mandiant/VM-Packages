$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v8.0.1/capa-v8.0.1-windows.zip"
$zipSha256 = "996eb9d0bc87dfd6143782f65412f96e52f87b21cdf9f49fe6a887518584541c"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
