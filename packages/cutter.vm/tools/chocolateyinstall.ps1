$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.3.0/Cutter-v2.3.0-Windows-x86_64.zip'
$zipSha256 = 'a708f0884421e7a90e95e5389697931ce5b282f8dfe0219b206b4837071bd770'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
