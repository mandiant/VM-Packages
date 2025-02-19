$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.netresec.com/networkminer/NetworkMiner_2-9.zip'
$zipSha256 = 'c610f6ba647ddd9c718e87018ee40595a4d72a52a6b3b7ceb53caf4fa8de6f05'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
