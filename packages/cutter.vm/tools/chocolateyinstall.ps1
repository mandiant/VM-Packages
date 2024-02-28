$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.3.3/Cutter-v2.3.3-Windows-x86_64.zip'
$zipSha256 = '1a0e52d42b5aacbb58cac55c25e579d6d3591a49fe672650f8037b73d96f4ac5'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
