$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.0.4/azurehound-windows-amd64.zip'
$zipSha256 = 'd1748d7bac190f14dc4a95cb872870ee0ebf57e6bdc000bb011fb4d92b0f500d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
