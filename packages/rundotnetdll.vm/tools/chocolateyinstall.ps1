$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RunDotNetDll'
$category = 'dotNet'

$zipUrl = 'https://github.com/enkomio/RunDotNetDll/releases/download/2.2/RunDotNetDll.zip'
$zipSha256 = '27B922861DD27C8DC484524EB7B3AE8F2FB6CA44C1C7086D9ED529A7B4E7CC1D'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

