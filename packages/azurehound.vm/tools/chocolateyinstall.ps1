$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.7/azurehound-windows-amd64.zip'
$zipSha256 = '9715c2ac8d6fc54e31be00a761e8e0b1831ee071465a61274377c7497341393a'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
