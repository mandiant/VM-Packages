$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v5.0.0/capa-v5.0.0-windows.zip"
$zipSha256 = "22bd744d7686a4ceb5fa9ef8ad55c7a06258b21209ff7cd3a030e99fe5863c31"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

