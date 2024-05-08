$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.9/azurehound-windows-amd64.zip'
$zipSha256 = '5422add82c8158aa88c23483d38f42c4d8de8e5f00dad811604c6710e40c33b1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
