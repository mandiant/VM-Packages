$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.0.1/SharpHound-v2.0.1.zip'
$zipSha256 = 'a6f73c1a75d14322aa4993fe498299ab55866ba74440f8a52d4dffe85594de2f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
