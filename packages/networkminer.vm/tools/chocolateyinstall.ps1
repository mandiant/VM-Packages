$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NetworkMiner'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.netresec.com/networkminer/NetworkMiner_3-2.zip'
$zipSha256 = 'daceec649fb4fe59b11e4a9e4ecd5f51c1dd37824280dfbeac67bec27b6b6d60'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
