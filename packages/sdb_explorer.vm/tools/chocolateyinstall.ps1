$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SDBExplorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/SDBExplorer.zip'
$zipSha256 = '22d7f8ea565f3b29a701a9542094534e4ca190a0d6e7fd95caefaabeb0e04568'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
