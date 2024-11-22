$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.5.8/SharpHound-v2.5.8.zip'
$zipSha256 = '413970222de555da19596792ccbe949c1389c630937d06910ad79d5e46dce930'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
