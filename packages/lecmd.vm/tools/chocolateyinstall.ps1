$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/LECmd.zip'
$zipSha256 = '60a1563049dca01ec88343b5c6eaf0f37e6a6b4016010db3c03f41fe19215bfa'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
