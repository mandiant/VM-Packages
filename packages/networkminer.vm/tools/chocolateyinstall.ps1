$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = 'Networking'

$zipUrl = 'https://www.netresec.com/?download=NetworkMiner'
$zipSha256 = '34e8ba09d6bb47463c0e154b7a8eef26922b8dd61000e95d1880aa8c175507e1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
