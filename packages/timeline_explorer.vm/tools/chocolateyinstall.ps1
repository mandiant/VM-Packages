$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TimelineExplorer'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/TimelineExplorer.zip'
$zipSha256 = '0542e719418d91ee7fa0d62a4b7af6003c72e8bd0ecc572ecd6fc0ab4c3a83e0'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
