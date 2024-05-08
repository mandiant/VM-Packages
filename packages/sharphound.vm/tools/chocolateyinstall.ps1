$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.4.1/SharpHound-v2.4.1.zip'
$zipSha256 = '2251b9a7c19ed7f416bdabc535c42682d838e512feef856e7e42c97287a6cd8e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
