$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v3.3/SQLRecon.exe'
$exeSha256 = '934b069bb6d8e7b03747dc90a00c94df491d8e7b2d8955793c317ce9361b8e19'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
