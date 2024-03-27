$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = 'Shellcode'

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.5/sclauncher.exe'
$exeSha256 = '63f4c0900cf972ea1d46544c8bc351567e842b084545079cd2f09023205202d5'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
