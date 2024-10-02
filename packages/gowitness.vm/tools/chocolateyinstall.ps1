$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.0.3/gowitness-3.0.3-windows-amd64.exe'
$exeSha256 = '047401ecad3cd6c5e3c80e816cb7c5b6e60bc27c142745742761c2cbeebf5bc9'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
