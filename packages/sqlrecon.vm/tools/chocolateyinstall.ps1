$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v3.9/SQLRecon.exe'
$exeSha256 = 'ec7cc5641356b27e2e4654e043382708d3fda1ede7989849f40832631e800566'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
