$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pestudio'
$category = 'PE'

$zipUrl = 'https://www.winitor.com/tools/pestudio/current/pestudio.zip'
$zipSha256 = '2069D3FF8BA5B523D4CCC76A8C8191A1510F04DAD75EA23E35EB0D14F8C97C07'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
