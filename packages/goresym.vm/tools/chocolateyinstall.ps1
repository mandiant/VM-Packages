$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'File Information'

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v2.7.4/GoReSym-windows.zip'
$zipSha256 = '075a9e7f6b5494e90b9880d1f8a91bd4c16841ff74bfc0c72253e3558aef8a38'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
