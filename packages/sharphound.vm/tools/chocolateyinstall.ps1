$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.3.3/SharpHound-v2.3.3.zip'
$zipSha256 = '78b0faf9c2d4afca5873ccc2f04bf9dbffdf76cf1b854f954d20a7335782ec95'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
