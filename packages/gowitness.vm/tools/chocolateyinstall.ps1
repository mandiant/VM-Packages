$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.2.2/gowitness-3.2.2-windows-amd64.exe'
$exeSha256 = '081edf246f12964b9e449698a1746642f61244710b24ca5d0df9edf1e1102d5b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
