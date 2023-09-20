$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.1.0/azurehound-windows-amd64.zip'
$zipSha256 = '12d89b6ae1865fdce3094899d9aae854c985d125e04f414d3a8cd2b083c34424'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
