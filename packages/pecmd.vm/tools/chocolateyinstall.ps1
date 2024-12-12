$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/PECmd.zip'
$zipSha256 = 'e20254b2f813e66fe5295488e5a00e9675679c91841f99ddcc8d083299bb55d6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -verifySignature $true
