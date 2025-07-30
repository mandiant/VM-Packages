$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'bstrings'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/bstrings.zip'
$zipSha256 = '6fb35d4e0b57726e5ff8c1641803306049bcfeed1adb0b93d5f59b88b4146a18'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
