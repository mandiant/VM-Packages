$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$Category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.1/SharpHound-v1.1.1.zip'
$zipSha256 = '224d47658e0e7ddc256eb97725179a35e42fed02f7717cf5b62afbae26dcb36b'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
