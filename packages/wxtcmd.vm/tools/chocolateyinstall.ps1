$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WxTCmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/WxTCmd.zip'
$zipSha256 = 'c8989a097f9440006484ee0b6a0b8e7181d043b2ba2a91b37760f23ab88901c3'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
