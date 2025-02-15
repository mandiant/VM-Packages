$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SrumECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/SrumECmd.zip'
$zipSha256 = '09762bdbd45ebaa4bd6e2cfa6dc8cdaea2092ee6b657420787098d8a6397e9c4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
