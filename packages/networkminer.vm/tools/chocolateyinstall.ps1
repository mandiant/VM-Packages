$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = 'Networking'

$zipUrl = 'https://www.netresec.com/?download=NetworkMiner'
$zipSha256 = 'cf477b651c3bcc70d6f5d50f9bdcb6d8cf2dd85b7018109ff474b9df3c7a0f7e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
