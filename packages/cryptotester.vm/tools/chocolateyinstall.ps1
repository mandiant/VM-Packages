$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CryptoTester'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Demonslay335/CryptoTester/releases/download/v1.7.3.0/CryptoTester.zip'
$zipSha256 = 'e126b7c95ef8e152fd8428ee98de165d97059668b374363132d6aa3936036840'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
