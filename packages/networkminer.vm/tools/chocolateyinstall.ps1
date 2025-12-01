$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.netresec.com/networkminer/NetworkMiner_3-1.zip'
$zipSha256 = '782e3d4d0b917a5aadf59966ab7d21ab30dbd593eff14e426f2b580a2e3f89e1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
