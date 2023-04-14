$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v2.2.1/SQLRecon.exe'
$exeSha256 = 'c5964a07d660f1488aa77093cf47187ccd53ea595c8981699a17019e56fc0863'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
