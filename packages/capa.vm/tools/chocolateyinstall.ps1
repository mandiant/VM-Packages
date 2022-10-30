$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v4.0.1/capa-v4.0.1-windows.zip"
$zipSha256 = "8a2f95b56c88d38b2f33be92cd3c320f090ce8bb6b9e563457b12e456f3e449f"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

