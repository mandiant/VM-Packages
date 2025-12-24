$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoWitness'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/sensepost/gowitness/releases/download/3.1.1/gowitness-3.1.1-windows-amd64.exe'
$exeSha256 = '26ea2da2d7d4ef04e60289c94ecfd43692d6eca3723cfe318a03bda7a43f9374'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
