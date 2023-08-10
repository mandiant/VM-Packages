$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.0.0/SharpHound-v2.0.0.zip'
$zipSha256 = '2b6ef9f4b59e06238caf0e4c79e023356784eff5d49313e7fae8539cc47a65ca'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
