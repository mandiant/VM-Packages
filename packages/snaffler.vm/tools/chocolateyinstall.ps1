$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.126/Snaffler.exe'
$exeSha256 = 'c27cfb7487f51e33a5964a64df0c3f0f4b5f94b64a428ae1817255d480b42472'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
