$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.6/azurehound-windows-amd64.zip'
$zipSha256 = '90950c43339256566338066c83e668f3f496cd3c3b85273620e951b080375ee6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
