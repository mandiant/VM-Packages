$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AppCompatCacheParser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/AppCompatCacheParser.zip'
$zipSha256 = '08be9f08cd2a4f0080ffb6ac336bdaa3ffd357efac632c2f6a1f5415a8c06a57'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
