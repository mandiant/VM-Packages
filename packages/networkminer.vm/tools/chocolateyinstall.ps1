$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.netresec.com/networkminer/NetworkMiner_3-0.zip'
$zipSha256 = '5d074a54e2f2f26d0a2cf5a2833ab08345f1a0eeba2bdf746835545ec23e3032'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
