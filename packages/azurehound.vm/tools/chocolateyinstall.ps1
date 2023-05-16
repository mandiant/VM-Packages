$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Cloud'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.0.3/azurehound-windows-amd64.zip'
$zipSha256 = 'c75860ece74b95e60f94aec5fd02e78b9579846bc1c35413d37a8344ef081834'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
