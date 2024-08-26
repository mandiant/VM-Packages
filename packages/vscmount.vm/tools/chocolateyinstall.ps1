$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCMount'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/VSCMount.zip'
$zipSha256 = '28927b892af255673432a962ac41f58f9be5cb3c7c0a2444556a01b033f066a7'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
