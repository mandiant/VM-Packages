$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTExplorer'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/MFTExplorer.zip'
$zipSha256 = '99947e91bbc19e440de7b1ff7a3557beed6ee79a3765eb67d58e4369ac711f1f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
