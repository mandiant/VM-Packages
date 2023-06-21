$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Information Gathering'

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/2.5.0/gowitness-2.5.0-windows-amd64.exe'
$exeSha256 = '6b563d157e5b6a0ffd7a360d97a00d55ea579ca6c7146c88f65e1de820e14097'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
