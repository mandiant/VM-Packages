$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio-9.56.zip'
$zipSha256 = '57f55e9e6c0db64dc28517efacc919e53dc6afef91ea1e6aa1fbd7be1ec35cbd'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
