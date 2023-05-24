$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CryptoTester'
$category = 'Utilities'

$zipUrl = 'https://github.com/Demonslay335/CryptoTester/releases/download/v1.7.0.0/CryptoTester.zip'
$zipSha256 = 'f1f6fe584fe697e3ec414854600781ae1906e7d28d9f370662a144821694539c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
