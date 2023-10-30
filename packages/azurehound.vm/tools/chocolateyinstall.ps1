$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.5/azurehound-windows-amd64.zip'
$zipSha256 = '830271d6e6cbbaebcbc2130c2aecf5c6ccfec048d7a66c3da9d283c0ca0360e0'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
