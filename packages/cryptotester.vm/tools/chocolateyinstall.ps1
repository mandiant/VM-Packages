$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CryptoTester'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Demonslay335/CryptoTester/releases/download/v1.7.2.0/CryptoTester.zip'
$zipSha256 = '3440ff6d2bb4f160709221fb3df8dae0c4a0f9c61414e4ea15c776b153431cca'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
