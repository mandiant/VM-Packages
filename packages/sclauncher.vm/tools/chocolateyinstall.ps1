$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = 'Shellcode'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.4/sclauncher.exe'
$exeSha256 = '524f56087655c9367e2c58f79fa2bd9c4c6be48e3328cfca3d62285f11335329'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
