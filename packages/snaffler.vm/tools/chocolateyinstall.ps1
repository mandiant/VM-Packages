$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.146/Snaffler.exe'
$exeSha256 = 'f1fd9e9170a4654219055b134a8f7fda8e11a0a8493d5bd641775db51586de17'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
