$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.3/azurehound-windows-amd64.zip'
$zipSha256 = '5cc2668971e79f20065f0e9ebbff2962a35d99e081da9b8cfd75041ec26e6624'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
