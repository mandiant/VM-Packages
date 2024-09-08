$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/RECmd.zip'
$zipSha256 = '90a1c5be877c3a50294a134b81fe26755980a70e6b9d914e444b43c1e205b0f3'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
