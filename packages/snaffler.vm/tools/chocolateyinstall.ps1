$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Snaffler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe'
$exeSha256 = 'a1b199edc5a0da958103e33521e371d733eb14fbbf85276ba40a3e882862dcca'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
