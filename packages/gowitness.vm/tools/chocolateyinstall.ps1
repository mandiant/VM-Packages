$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.0.4/gowitness-3.0.4-windows-amd64.exe'
$exeSha256 = 'f47ca3f6f2f23bb56536150e0f2bed2e5deceda07115d1ef08957b40436ce783'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
