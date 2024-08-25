$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.170/Snaffler.exe'
$exeSha256 = 'b8a279b6576b3aa7f7ae8e4a44d5ab9b51ffdab7b5409582d7f7cbe02cfb6229'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
