$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SBECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/SBECmd.zip'
$zipSha256 = '76e68ea696cb94f3a26c5c05e01467bdd8e18503fabd55ce4065448251071595'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
