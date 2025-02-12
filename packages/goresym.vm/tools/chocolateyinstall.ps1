$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'File Information'

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.0.2/GoReSym-windows.zip'
$zipSha256 = '8bf91fe0104a7b15f97e665cc4f0055409b8bc824e762fd72d69d5f0ce6f8942'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
