$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v7.3.0/capa-v7.3.0-windows.zip"
$zipSha256 = "fc37549772c51fc48a0505bd38fff8ba5faaf9be1c9f1f04328641d46aee6163"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
