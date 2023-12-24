$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/2.5.1/gowitness-2.5.1-windows-amd64.exe'
$exeSha256 = 'c8536db178e87bf5db221c405de047e1e27ed260dda0837542d5a09e3845834c'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
