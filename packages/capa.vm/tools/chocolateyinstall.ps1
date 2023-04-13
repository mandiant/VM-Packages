$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v5.1.0/capa-v5.1.0-windows.zip"
$zipSha256 = "80ac9adfd095cb631a6fa39743b37444651e4129b4181fd34c8b8b3e53bc5b06"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

