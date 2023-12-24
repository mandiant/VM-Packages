$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.3.0/SharpHound-v2.3.0.zip'
$zipSha256 = 'dd6e426856acc656cadd4587fa002d4fe50f3370915932256887fa3d9d016687'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
