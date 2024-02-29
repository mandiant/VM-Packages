$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TotalReg'
$category = 'Registry'

$exeUrl = 'https://github.com/zodiacon/TotalRegistry/releases/download/v0.9.7.8/TotalReg.exe'
$exeSha256 = 'ad3db638738eb5433fec88ad6b3954e55f9ce3f8dcba45256d70f78b3d6dff8c'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
