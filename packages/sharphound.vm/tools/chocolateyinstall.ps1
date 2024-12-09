$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.5.9/SharpHound-v2.5.9.zip'
$zipSha256 = '98860d5110dbc81f0e83681a6977bbefe0b987f98346847a35b254ec5c0994aa'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
