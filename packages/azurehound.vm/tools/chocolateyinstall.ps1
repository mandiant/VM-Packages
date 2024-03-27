$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.8/azurehound-windows-amd64.zip'
$zipSha256 = '3a742f43c5a6becde1e1239ed1585467aa957d34d5c89118b7d916e2e6bf7f38'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
