$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v7.1.0/capa-v7.1.0-windows.zip"
$zipSha256 = "c578b962510e73ad31d7200a7b05e50b1867b7ee5290d271bd5b12094a3da186"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
