$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'File Information'

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v2.4/GoReSym-windows.zip'
$zipSha256 = '6d253e98fce443b5c818e0ae0c0f0a4e3587e0f0f7baf150383ead242e01babd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
