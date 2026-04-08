$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v4.0/SQLRecon.exe'
$exeSha256 = '3afce83fab12cdb4fa8439d8f1dfe2146a6a8c0e4b9761c6ee266f601027916b'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
