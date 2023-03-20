$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Cloud'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v1.2.4/azurehound-windows-amd64.zip'
$zipSha256 = '72ebef899983f87292dfa87e8de0bad1177f0dc7efd73bf6df75483b1e15389e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
