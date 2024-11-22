$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = 'File Information'

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.0.1/GoReSym-windows.zip'
$zipSha256 = 'f8fdf6b597222cb8f6fcb92961b3a5b537d799cc152b909dd95cb09d4efe830e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
