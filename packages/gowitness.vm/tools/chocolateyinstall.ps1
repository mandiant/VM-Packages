$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.2.0/gowitness-3.2.0-windows-amd64.exe'
$exeSha256 = '6aaa0cfedd255685824402bad07a295013919d4417af06431978214cd4402f4c'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
