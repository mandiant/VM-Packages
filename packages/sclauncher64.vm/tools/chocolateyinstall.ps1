$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = 'Shellcode'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.5/sclauncher64.exe'
$exeSha256 = 'e7ec06d0f0110a4892d2c026f57392f36b25433cfc114fbcba81041a44d970c8'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
