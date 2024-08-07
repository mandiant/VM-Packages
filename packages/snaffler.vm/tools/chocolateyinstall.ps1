$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.154/Snaffler.exe'
$exeSha256 = '4a4cd90ca03c99de99ca12fbe43348f74af045b214c97fd4841fbdf4887601ac'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
