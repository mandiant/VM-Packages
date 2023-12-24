$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.140/Snaffler.exe'
$exeSha256 = '71bb8b15b1fbab1ebe7cd7898397d8a8a627af06dc510437f25887aa0aa0e4e1'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
