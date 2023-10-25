$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.4/azurehound-windows-amd64.zip'
$zipSha256 = '1607160ae684da22346cb9df960e8702d5d717d2bb64c2a3882234694b58de0c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
