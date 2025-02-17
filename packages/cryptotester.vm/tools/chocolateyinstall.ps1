$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CryptoTester'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Demonslay335/CryptoTester/releases/download/v1.7.1.0/CryptoTester.zip'
$zipSha256 = '3d354ce4f66a023dfa3cfcb3beac06d5b7be331d6f247035ee7957e5af64fac3'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
