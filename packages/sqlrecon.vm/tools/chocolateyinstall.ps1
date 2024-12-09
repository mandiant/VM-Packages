$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v3.8/SQLRecon.exe'
$exeSha256 = '979e62d0b229c4e988ea4b655cd7d26a992c3eb1457c9418b6ac42ad79f4d756'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
