$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.3.2/SharpHound-v2.3.2.zip'
$zipSha256 = '3002ae0a5cc844b862c99f1d561f9530df8d6259f970d038baeac665a153b91c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
