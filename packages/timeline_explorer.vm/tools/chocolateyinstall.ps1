$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TimelineExplorer'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/TimelineExplorer.zip'
$zipSha256 = '61aceca2e41f62d52ce67642c9881789b0be070f18526dbe2e60a163a4ceb2f6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
