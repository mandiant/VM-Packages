$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/MFTECmd.zip'
$zipSha256 = '9beb6bb054df4806023937548bec212177cb8967f6f4d84b73a4e35fb13b8a50'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
