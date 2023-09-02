$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.3.1/Cutter-v2.3.1-Windows-x86_64.zip'
$zipSha256 = '52939105aff4f5b5ce82e17ddcd62e9cfb3c14684c1cbf98e6f485af1e47b074'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
