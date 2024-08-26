$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RecentFileCacheParser'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/RecentFileCacheParser.zip'
$zipSha256 = '4b9760b75f4e91269e55d9a03b0b0572b3ed90948f2a08cc6c1215e2e00e3353'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
