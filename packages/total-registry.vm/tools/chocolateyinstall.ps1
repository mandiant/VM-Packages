$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TotalReg'
$category = 'Registry'

$exeUrl = 'https://github.com/zodiacon/TotalRegistry/releases/download/v0.9.8/TotalReg.exe'
$exeSha256 = 'e5b603efad3138900df44735e7b430bfd1bc5e34a265c7e92c01e444e848b211'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
