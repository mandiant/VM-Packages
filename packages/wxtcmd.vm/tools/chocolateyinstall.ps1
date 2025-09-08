$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WxTCmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/WxTCmd.zip'
$zipSha256 = 'C8989A097F9440006484EE0B6A0B8E7181D043B2BA2A91B37760F23AB88901C3'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
