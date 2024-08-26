$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TimelineExplorer'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/TimelineExplorer.zip'
$zipSha256 = '9e6f008102fcf62148856dad03f310b11b4c586495985fd3d3e333497c6fee2b'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
