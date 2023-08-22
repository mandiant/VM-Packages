$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.132/Snaffler.exe'
$exeSha256 = '436108e86eced22b3384bc129b7a16a5f50821b98aa146847e94f595d130b235'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
