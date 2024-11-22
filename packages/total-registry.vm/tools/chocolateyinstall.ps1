$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TotalReg'
$category = 'Registry'

$exeUrl = 'https://github.com/zodiacon/TotalRegistry/releases/download/v0.9.7.9/TotalReg.exe'
$exeSha256 = 'e83ae98b6492e22d05e6c49240fda8e4dd68f24c5cf79afc854d5441e7e91f80'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
