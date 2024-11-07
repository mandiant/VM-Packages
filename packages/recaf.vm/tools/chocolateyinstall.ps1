$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'recaf-2.21.14-J8-jar-with-dependencies'
$category = 'Java & Android'

$exeUrl = 'https://github.com/Col-E/Recaf/releases/download/2.21.14/recaf-2.21.14-J8-jar-with-dependencies.jar'
$exeSha256 = '8d14fc007e2a90a0d2331e5170cfce0f899ad96631aa7565623dea997c6bcb84'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
