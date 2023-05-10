$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Cloud'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.0.2/azurehound-windows-amd64.zip'
$zipSha256 = '83b731e4cc8d221ed147a2264b0933c7101b95f7d1eddb9ad259e132e87fa246'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
