$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.0.5/gowitness-3.0.5-windows-amd64.exe'
$exeSha256 = '45284210727f2d22774e07313db974a0fe9e9108687a7c091218e7e98b041bea'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
