$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SDBExplorer'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/SDBExplorer.zip'
$zipSha256 = 'c88085e74405801f9d4f2557ce35eaa6316e6fe812e5efd66a6a1d87f1b1cbd6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
