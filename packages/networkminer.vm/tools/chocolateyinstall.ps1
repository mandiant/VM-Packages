$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = 'Networking'

$zipUrl = 'https://www.netresec.com/?download=NetworkMiner'
$zipSha256 = '13dc519e24a44485554be6e3651bf9381b9ea13a0376cdf958508c75e3b1bb7a'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
