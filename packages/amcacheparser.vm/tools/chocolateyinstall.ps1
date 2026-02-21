$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AmcacheParser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/AmcacheParser.zip'
$zipSha256 = '334D03D26B1261646B06401BBB77E5FBE74BF0C4C636C2479B0F53CFB094EA81'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
