$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v7.2.0/capa-v7.2.0-windows.zip"
$zipSha256 = "0195820c6d2dc71dfb693725d320e3440805025d732fe49963b5aa3011f58c53"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
