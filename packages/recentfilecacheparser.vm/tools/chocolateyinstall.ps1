$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RecentFileCacheParser'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/RecentFileCacheParser.zip'
$zipSha256 = '2b9eb1946bb3f58d2f61ab44671ac46fe4b0dd75c70972cb468f79844455df7f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
