$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.150/Snaffler.exe'
$exeSha256 = '436b04e8ea3b4a15ac0ab391ebf7709ee3142b37062ee60ff9c81cd7dbd6f052'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
