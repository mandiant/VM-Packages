$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Cutter'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/rizinorg/cutter/releases/download/v2.2.0/Cutter-v2.2.0-Windows-x86_64.zip'
$zipSha256 = 'd0fad5ee098ecfa62e705c868b5e1032066c34c4ff66160c3b1423801a877611'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
