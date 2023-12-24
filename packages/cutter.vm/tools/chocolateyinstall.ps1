$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.3.2/Cutter-v2.3.2-Windows-x86_64.zip'
$zipSha256 = 'e53a137809a610f939ce13744640f0da67369e87fdb1b2545be3e417c7781c8e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
