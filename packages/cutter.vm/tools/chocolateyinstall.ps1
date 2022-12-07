$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.1.2/Cutter-v2.1.2-Windows-x86_64.zip'
$zipSha256 = '9BD08FC9D5591149D3E6FEE3E269458E3781706C09C2C1FF49355E48D27C0486'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
