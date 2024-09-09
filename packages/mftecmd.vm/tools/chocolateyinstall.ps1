$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/MFTECmd.zip'
$zipSha256 = '705cebd566987e815c7e2ac6d0159d200223065817a6f115b4ce5ba61a22b424'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
