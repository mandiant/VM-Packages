$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.2.1/Cutter-v2.2.1-Windows-x86_64.zip'
$zipSha256 = '2871e93e01881ba31e1c3fbdc7e4ccfb3114b3d95cad64a93fefa933846cadb4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
